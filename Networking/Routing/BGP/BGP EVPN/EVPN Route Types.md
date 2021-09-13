# EVPN Route Types
| Route Type | What it carries                | Primary use                                                                                        |
|:---------- |:------------------------------ |:-------------------------------------------------------------------------------------------------- |
| RT-1       | Ethernet Segment Auto Discover | Supports multihomed endpoints in the data center, used instead of MLAG                             |
| RT-2       | MAC, VNI, IP                   | Advertises reachability to a specific MAC address in a virtual network, and its IP address         |
| RT-3       | VNI/VTEP Association           | Advertises a VTEP's interest in virtual networks                                                   |
| RT-4       | Designated Forwarder           | Ensures that only a single VTEP forwards multidestination frames to multihomed endpoints           |
| RT-5       | IP prefix, VRF                 | Advertises IP prefixes, such as summarized routes, and the VRF associated with the prefix          |
| RT-6       | Multicast group membership     | Contains information about which multicast groups an endpoint attached to a VTEP interested in it | 


## RT-2
When ARP/ND suppression or routing is disabled, only the RD, MAC address, and
MPLS Label1 fields in the message are used. The MAC address length field is always set to six, the MAC address field carries the MAC address, and the MPLS Label 1 field carries the L2 VNI associated with the MAC address.

EVPN RT-2 message format
![[Pasted image 20210725150012.png]]

When ARP/ND or routing is enabled, the IP address associated with the {VNI, MAC} is also advertised. Implementations might choose to send two separate RT-2 advertisements, one for just the MAC and the other for the MAC/IP, or just a single MAC/IP advertisement.

When only asymmetric routing is used, MPLS Label1 carries the L2 VNI associated with the MAC/IP binding, and MPLS Label2 is not used. When symmetric routing is used, MPLS Label2 field carries the L3 VNI.

