# How EVPN replaces the 802.Q flood-and-learn
The primary difference is that EVPN uses BGP to distribute reachability to MAC addresses and IP routes along with the associated virtual network. Also, STP is not used.

![[Pasted image 20210725001730.png]]

The leaves are the VTEPs. To function as a VTEP, they need an IP address to source and receive packets. Typically, a single IP address is used across all VNIs.

EVPN has also been enabled on all the leaves. 802.1Q bridging is enabled only on the ports between a leaf and the servers locally attached to it, as in a Clos network.

The spines are only part of the underlay.

Assume that the red VLAN (represented by the thick line) is mapped to the red VNI, and the blue VLAN (represented by the thinner line) to the blue VNI.

Different leaves can associate a subnet with different VLAN IDs as long as all those different VLAN IDs map to the same global VNI. All information exchanged in EVPN is about the global VNI, not the local VLAN instantiation of it. Thus, the subnet is also associated with the global VNI because it spans multiple routers.

Every leaf has a second IP address, the VTEP IP address, associated with it in the 10.0.127.0/24 subnet; all VXLAN-encapsulated packets will have the source and destination IP address from this subnet. The network administrator must also ensure that this VTEP IP address is advertised via BGP; otherwise, the other VTEPs will not know how to reach this address.

Each leaf learns about the virtual networks every other leaf is interested in via RT-3 routes. So leaf01 knows that leaf02 and leaf04 are interested in the red VNI, and leaf03 and leaf04 are interested in the blue VNI. Similarly, other leaves learn this information from the BGP UPDATEs.


## EVPN Bridging with Ingress Replication
Let’s have server101 send a packet to server104. Because server101 and server104 belong to the same subnet, server101 sends an ARP request packet asking for server104’s MAC address. This goes in the form of a Ethernet broadcast packet with the destination MAC101 of FF:FF:FF:FF:FF:FF and a source MAC address.

1. The packet sent from server101 to leaf01 is no different in this case from traditional bridging. leaf01 receives this packet and, just as in traditional bridging, learns that MAC101 is reachable via the port attached to server101. leaf01 understands that the packet is a broadcast packet and so needs to be sent to all the recipients of the red VNI. leaf01 uses head-end replication to flood the packet to all the interested leaves—in this case leaf02 and leaf04.

2. Leaf01 VXLAN encapsulates the packet and sends one copy to spine01 (destined to leaf02) and one to spine02 (destined to leaf03). The packet to leaf02 has the destination IP address of leaf02’s VTEP—for instance 10.0.127.12—and the source IP address of leaf01, 10.0.127.11. Similarly, the packet to leaf04 has the destination IP address of 10.0.127.14 and the source IP address of 10.0.127.11.

3. When spine01 receives the packet, it does a routing lookup of the IP in the VXLAN header, which is that of leaf02. It then routes the packet out the port to leaf02. spine02 does the same for the packet destined to leaf04.

4. When these VXLAN-encapsulated packets reach leaf02 and leaf04, they each know that they are the egress VTEP because the destination IP address in the packet is their IP address and the UDP destination port says that this is a VXLAN packet.
	
	They decapsulate the packet and use local 802.1Q bridging to determine the locally attached ports to which to send the packet out


Neither leaf02 nor leaf04 learn anything about MAC101 from this flooded packet. However, leaf01 has a new local entry in its MAC forwarding table. So leaf01 advertises the reachability to MAC101 in the red virtual network via a BGP UPDATE message. Specifically, it uses an EVPN RT-2 message, which carries the {VNI, MAC} advertisement. The message says that MAC101 in the red virtual network is reachable via the VTEP leaf01. leaf01 delivers this information to its BGP peers, spine01 and spine02. spine01 and spine02 in turn deliver this message to their peers, which are leaves leaf02, leaf03, and leaf04. The leaves receive multiple copies of the updates, one from each of the spines. 

These leaves now populate their MAC forwarding tables with information about MAC101. They note that MAC101 is remote and reachable via the leaf01’s VTEP IP address, 10.0.127.11. leaf03, which has no red VNI, simply stores this message (or can discard it).

If server104’s ARP reply to server101 arrives before the MAC table update on leaf04, the return packet can be flooded just like the broadcast packet because leaf04 doesn’t know about MAC101 yet. If the ARP reply arrives after leaf04 has updated its MAC table based on the BGP UPDATE from leaf01, the reply can be sent directly only to leaf01.

Leaf04 also learns that MAC104 in the red VNI is attached to the local port pointing out to server104. leaf04 sends a BGP UPDATE message with an EVPN RT-2 type indicating that MAC104 in the red VNI is reachable via leaf04. This message is delivered to both spine01 and spine02. They deliver this BGP UPDATE to all the other leaves. At the end of the BGP processing, leaf01, leaf02, and leaf04 know that MAC101 in the red VNI is reachable via VTEP leaf01 and that MAC104 in the red VNI is reachable via leaf04.


### Primary differences between EVPN bridging from traditional 802.1Q bridging

- Inserting the remote MAC address into the MAC table is done via BGP UPDATEs in EVPN, instead of learning from the data packet itself in 802.1Q

- The path of the reply from server104 to server101 can take a different path compared to the packet from server101 to server104 in EVPN, whereas they're the same in 802.1Q bridging.

### Common between EVPN bridging and 802.1Q bridging

- Locally attached MACs are populated in the MAC table via standard 802.1Q learning
- Flooded packets are delivered to all end stations in the virtual network
- Each {virtual network, MAC address} tuple is associated with a single egress port

## Handling MAC Moves

![[Pasted image 20210725001730.png]]

Let server101 host a VM with a MAC address of MACVM 101. After it first speaks, using the model of EVPN bridging, all leaves learn that MACVM101 is
being associated with VTEP leaf01. 

Now consider what happens if the VM now migrates to server102. When it first speaks after the move, leaf02 learns that MACVM101 is locally attached to itself. It also has an entry that states that MACVM101 is associated with leaf01 populated via BGP. Because locally attached entries take precedence over entries learned via BGP, leaf02 switches its MAC table to have MACVM101 point out the port to server102. It then sends out a BGP EVPN RT-2 UPDATE message indicating that others should switch their association for MACVM101 to leaf02. leaf04 does so without a problem. But leaf01 thinks that MAC address is locally attached to itself. Because locally attached entries take precedence over entries learned via BGP, leaf01 will not switch its association for MACVM101 to leaf02, but continues to think it is locally attached. This is wrong. 

To fix this issue, EVPN defines a new BGP extended community called MAC Mobility. [[BGP Communities]]

![[Pasted image 20210725115309.png]]

The first basic rule about using this extended community is that it must be used for advertising a MAC address that is locally learned, if the MAC address is already associated with a remote VTEP.

The `sequence number` indicates the number of times this MAC address has moved. For instance, the first time this attribute is attached to an RT-2 advertisement of a MAC address, the sequence number is bumped to 1.

The second basic rule is that if you receive an advertisement for a MAC address in a virtual network with this extended community, you must accept this advertisement as the best path either if you don’t hold an entry with this extended community or if the sequence number in the new advertisement is higher than the one currently in your database. In case multiple updates are received with the same sequence number but from different VTEPs, the one with the lower VTEP IP address wins.

Static MAC addresses are MAC addresses that are not allowed to move. When advertising such MAC addresses, the route must be tagged with the MAC Mobility extended community with the “S” bit in the community set. When any VTEP receives a MAC advertisement with such a tag, it must ignore any locally detected changes in that MAC address in the associated virtual network.

### Incorrect MAC moves

Sometimes, messages indicating that a MAC address moved are incorrect. One reason is lax security in L2 networks, making it possible to spoof a MAC address and make it move from a safe host to a compromised host. Another reason for spurious moves is that a problem in a connected 802.1Q network can cause the STP to continuously update its tree. When the tree is updated, a MAC address might appear in a different location in the tree, making it look like the MAC address moved.


To handle all of these cases, if a VTEP detects that a MAC address is updating too frequently, it can stop sending or handling further updates to that MAC address. It must also notify the administrator that this is happening. There is no clearly defined way to get out of this situation.

FRR’s EVPN implementation supports MAC Mobility as defined by the standard. If it detects that a MAC address has moved too many times within a specified time period, it ignores MAC address updates associated with the MAC address for some time, before restarting the MAC Mobility timer. The number of moves and the time periods can all be specified.

## Support for Dual-Attached Hosts

![[Pasted image 20210725123337.png]]

### VXLAN Model for Dual-Attached Hosts

Most packet-switching silicon implementations as of this writing assume that a MAC address is behind a single VTEP.

There are two possibilities: each VTEP has its own IP address or both VTEPs share a common IP address. The shared VTEP IP address is the most common deployment. The main reason for this is that the common implementation of a MAC forwarding table supports only a single port of exit. 

leaf01 and leaf02 will both transmit packets for all dual-attached hosts with a source VTEP IP address that is common to them both. Most implementations verify that the switches have the same common IP address configured via a protocol such as the Multichassis Link Aggregation (MLAG)

### Switch Peering Options

Before we proceed to look at the other problems and how they are handled, we must examine the model adopted by the pair of switches to which the dual-attached hosts are connected. There are essentially two answers: MLAG and EVPN.

#### MLAG

The standard LACP does not support creating a bond when the links are split at one end across multiple devices. Therefore, every networking vendor has their own proprietary solution to provide that illusion. The generic name for this solution is MLAG.

#### EVPN support for multihoming

EVPN supports dual-attached devices natively. It calls them multihomed nodes.
Primarily, EVPN uses RT-1 and RT-4 message types to handle multihomed nodes. RT-1 tells the network which switches are attached to which common
devices or Ethernet segments. An Ethernet segment in a data center is defined as either the bridged network to which a VTEP is connected or a bonded link.
[[EVPN Route Types]]

When connected to a bond, the RT-1 advertisement carries the LACP identifier of the remote node (i.e., the host in our case) as the Ethernet segment ID (ESI). When other VTEPs receive the BGP updates of this RT-1 advertisement, they can determine which of their peers are attached to the same host.

RT-4 elects one of the peers as the designated forwarder for multidestination frames. The RT-4 advertisement carries the mapping of the Ethernet segment to the router servicing the segment. From all the advertisements received for an Ethernet segment, each VTEP selects the segment with the lowest VTEP IP address as the designated forwarder for a virtual network. In this case, a common VTEP IP address is not required across the two peers.

Let’s break this down using our sample topology. First, the standard allows leaf01 to be the designated forwarder for one set of nodes—say server101 and server201—and leaf02 to be the designated forwarder for another set of nodes—say server102. In [[Pasted image 20210725123337.png]], each host carries only a single VLAN. But if the hosts supported multiple VLANs, the standard further allows leaf01 to be the designated forwarder for a node —say server101—for one set of VLANs, and leaf02 as the designated forwarder for that node for a different set of VLANs.

### Handling Link failures

#### MLAG

In the case of MLAG, using the peer link to reach the host via the other switch is the most common implementation. 

In our example, both leaf01 and leaf02 advertise reachability to server102 via a common VTEP IP. The underlay multipaths traffic addressed to the common VTEP IP between leaf01 and leaf02. When leaf01 loses its connectivity to server102, it withdraws its advertisement of server102. However, because leaf02’s advertisement is still valid, leaf03 and leaf04 see that MAC102 is still
reachable via the common VTEP IP. So, a packet to server102 can still end up at
leaf01, even though the link between them is down and leaf01 cannot deliver the packet directly. In such cases, leaf01 decapsulates the packet and uses the peer link to send the packet unencapsulated to leaf02, which then delivers the packet to server102.

#### EVPN Multihoming

In EVPN multihoming implementations, the switch that lost the connectivity to the host will also withdraw reachability to the ESI identified by the LACP of the host. This is done for both RT-1 and RT-4 routes.

The other switch eventually receives these withdrawals. On receiving the RT-4 withdrawal, the remaining switch appoints itself the designated forwarder for server102. Receiving the RT-1 withdrawal tells the switch that the host is singly attached to it. The switch cannot attempt to forward the packet to its peer when it loses connectivity to the host. In our example, when leaf02 receives the withdrawal originated by leaf01, it knows that if it loses the link to server102, it cannot forward a packet to leaf01. However, reencapsulating a VXLAN packet without routing violates the split-horizon check. 

#### Avoiding Duplicate Multidestination Frames

When the common VTEP IP model and ingress replication are used, only one of the pair of switches gets a packet. This is because the other VTEPs represent the pair with a single common VTEP IP address, and one is chosen at random to get an anycast packet. However, in the model without a shared common VTEP IP address, both switches will get a copy of multidestination frames (BUM packets, for example). To ensure that only one of the pair sends a packet to the end station, the two nodes use the RT-4 message to pick only one of them to deliver a multidestination frame in a virtual network. However, control protocol updates take time, and during the process of electing a designated forwarder or during transitions, the host can either receive no multidestination frames or receive duplicates.