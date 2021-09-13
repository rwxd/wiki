# Cumulus Fabric with VXLAN EVPN & BGP

## About
A clos topology switching fabric will be build in this page.

Heavily inspired by the Book [[Cloud Native Data Center Networking]]

## Interfaces

## Switch Ports

```cfg
auto swp5s0
iface swp5s0
 alias Cohesity
 link-speed 25000
 link-duplex full
 bridge-vids 103 107 108
```


## Bridge

```cfg
iface bridge
 bridge-vlan-aware yes
 bridge-ports swp3s0 swp3s1 vni10100 vni10101
 bridge-vids 100 101 102 103
 bridge-pvid 1
```

`bridge-vlan-aware yes` The VLAN-aware mode in Cumulus Linux implements a configuration model with one single instance of Spanning Tree. Each physical bridge member port is configured with the list of allowed VLANs as well as its port VLAN ID. This significantly reduces the configuration size, and eliminates the large overhead of managing the port/VLAN instances as subinterfaces.

`ifreload -a` to reload interface configuration

`bridge-pvid 1` sets the native VLAN. The Primary VLAN Identifier (PVID) of the bridge defaults to 1. You do not have to specify `bridge-pvid` for a bridge or a port. However, even though this does not affect the configuration, it helps other users for readability

By default, the bridge port inherits the bridge VIDs, however, you can configure a port to override the bridge VIDs.

## SVIs

```cfg
auto vlan103
iface vlan103
 alias COHESITY
 vlan-id 103
 address 10.136.16.14/24
 address 2a00:e400:2:250::14/64
 address-virtual 02:0a:88:10:00:67 10.136.16.1/24
 address-virtual 06:00:02:02:00:67 2a00:e400:2:250::1/64
 vlan-raw-device bridge
 vrf xal-001
```

`address` is the unique IP address of the leaf on the specified VNI.

`address-virtual` is shared across all the leaves that carry this VNI. Servers are configured to use this IP address as the default gateway address to allow a server to be attached to any rack and not have to change its default gateway configuration.

`vxlan-raw-device bridge` Linux allows the presence of multiple 802.1Q bridges on the same device. An in interface is assigned to only of of the bridges and so there is no ambiguity on the link about the use of a VLAN.

## VXLAN Interfaces
```cfg
auto vni10100
iface vni10100
 bridge-access 100
 bridge-arp-nd-suppress on
 bridge-learning off
 mstpctl-bpduguard yes
 mstpctl-portbpdufilter yes
 mtu 9166
 vxlan-id 10100
 vxlan-local-tunnelip 10.136.128.3
```

`iface vni10100` Each VXLAN VNI is represented by a device in the Linux kernel

`bridge-access` maps the VNI to a local VLAN ID

`bridge-learning off` We don't want to enable learning of remote MAC address because we have EVPN. So we disable learning on the VNIs.

`mstpctl-bpduguard yes` You can configure _BPDU guard_ to protect the spanning tree topology from unauthorized switches affecting the forwarding path. For example, if you add a new switch to an access port off a leaf switch and this new switch is configured with a low priority, it might become the new root switch and affect the forwarding path for the entire layer 2 topology.

`mstpctl-portbpdufilter yes` You can enable `bpdufilter` on a switch port, which filters BPDUs in both directions. This disables STP on the port as no BPDUs are transiting.

`vxlan-local-tunnelip 10.136.128.3` This specifies the local source IP address to be used when CLAG isn't operational. When CLAG is operational, the address specified in point 2 is used as the tunnel source IP address.

## VRFs
```cfg
auto xal-001
iface xal-001
 vrf-table auto

auto xal-002
iface xal-002
 vrf-table auto
```

`vrf-table auto` table id is automatically assigned

## Routing

### BGP

#### Overlay and underlay
The BGP process on the spines needs to retain information it receives about both the overlay and the underlay. It uses the underlay information to build the underlay packet forwarding table. It needs to retain the overlay information it receives from a leaf to pass it to the other leaves (functioning like a RR). However, the spines don’t know anything about virtual networks and will drop the information about them unless otherwise instructed. FRR automatically makes the spines keep that information when it recognizes that the same session is used for carrying both underlay and overlay routes. In other vendor implementations that support a single eBGP session model, additional configuration might need to be added.

#### Unnumbered BGP

##### IPv6 link-local address

When enabled on a link, IPv6 automatically generates an IPv6 address that is valid only on that link, a link-local address (LLA). Most often, the interface MAC address is used to generate the address. IPv6 LLAs have a well-defined format: they start with fe80. An example of an IPv6 LLA is fe80::5054:ff:fe6d:4cbe.

Unnumbered BGP uses this LLA to set up the TCP connection. Instead of asking the user to specify this, FRR uses the interface name to understand that the user wants to use the IPv6 LLA to establish the BGP peering. So, if fe80::5054:ff:fe6d:4cbe is the IPv6 LLA of the interface, FRR expects to receive a connect request on that address from the peer on that interface. Alternatively, it uses that address to send the connect request to the peer. However, to establish a connection with a remote entity, BGP needs the IPv6 LLA of the interface on the other end of the link. How does a node get that automatically?
Via IPv6 router advertisement.

##### IPv6 router advertisement

To allow hosts and routers to automatically discover neighboring routers, IPv6
designers added router advertisement (RA). RA is one of the messages used in IPv6’s NDP. IPv6 NDP is the IPv6 equivalent of IPv4’s ARP. When enabled on an interface, RA periodically announces the interface’s IPv6 addresses, including the LLA. Thus, one end can automatically determine the other end’s IPv6 address. Like IPv6, RA is universally implemented these days on both hosts and routers.

The IPv6 LLA is used only to establish a TCP connection for starting a BGP session. Besides enabling IPv6 on a link, which is typically enabled automatically, and the enabling of the IPv6 router advertisement on the link, no other knowledge of IPv6 is expected of the operator.

##### RFC 5549

Establishing a TCP connection over IPv6 LLA isn’t enough. To exchange IPv4 routes, we need a next-hop IPv4 address. But the interface on which BGP peering has been established has no IPv4 address and there is no other reachable IPv4 address for the router to advertise. So how does this work? There are two parts to this: a control-plane part and a packet forwarding (or data plane) part. The control-plane part involves implementing a standard, well-defined extension to encoding BGP’s next-hop value. That standard is defined in RFC 5549, which is titled “Advertising IPv4 Network Layer Reachability Information with an IPv6 Next Hop.” Remember, an IPv4 NLRI is just the route. So, this RFC defines how to advertise an IPv4 route with a next-hop IPv6 address. 

As with any other BGP extension, the support for encoding and processing an IPv4 route with an IPv6 next hop is first negotiated as part of the capability exchange in the BGP OPEN message. Only if both sides of a peering session support this capability is this method of advertising IPv4 routes with IPv6 next hop used. The BGP capability to indicate support for RFC 5549 is called extended next hop.

The IPv6 RA gives us not only the link-local IPv6 address of the peer router, but also the MAC address of the peer interface on that router. So, for any given IPv6 link local address, we have its corresponding MAC address. Packet-switching silicon typically has a route pointing to a group of next hops, and each entry in the next hop only contains the MAC address (and VLAN). So the packet-switching silicon’s routing table can be populated with an IPv4 route with the next-hop MAC address with this information. Thus, the information from the RFC 5549 encoding can be used to populate the packet-switching silicon just as if we had received an IPv4 route with an IPv4 next-hop address.

###### RFC 5549 with FRR

The next-hop router’s IP address is needed for only one trivial thing: it appears in the output of commands displaying the route. You can work around this by using a dummy IPv4 address. FRR uses 169.254.0.1 as this dummy IPv4 address.


##### How FRR implements Unnumbered BGP

1. FRR implements IPv6 RA natively. FRR’s RA when enabled on an interface announces its own LLA and MAC address. RA packets are used with a link-local multicast address and so they’re never forwarded.

2. On receiving an RA packet from a peer router on an interface, FRR’s RA extracts the MAC address and the associated IPv6 LLA.

3. Now that the interface’s peering address is known, FRR kicks BGP into action to start connection establishment using the learned IPv6 LLA.

4. After a successful BGP connection establishment, BGP uses capability negotiation to ensure that both sides of the peering session support RFC 5549.

5. BGP receives a route advertisement for a route, say 10.0.0.11/32, from the peer with the peer’s IPv6 LLA (and global IPv6 address if one is configured).

6. If BGP selects this path as the best path to reach 10.0.0.11/32, it passes this route down to the RIB process (called zebra in FRR), with the next hop set to the IPv6 LLA received in the BGP UPDATE message.

7. Let’s assume the RIB picks this BGP route as the best route with which to populate the FIB. The RIB process now consults its database to see whether it has the information for the MAC address associated with this IPv6 LLA. It sees that there is such an entry.

8. The RIB process now adds a static ARP entry for 169.254.0.1 with this MAC address, with the peering interface as the outgoing interface.

9. The RIB process then pushes the route into the kernel routing table with a next hop of 169.254.0.1 and an outgoing interface set to that of the peering interface.

![[Pasted image 20210724145412.png]]

```
interface {{ swp.name }}
 ipv6 nd ra-interval 5
 no ipv6 nd suppress-ra
!

router bgp 65011
	bgp router-id 10.0.0.11
	neighbor ISL capability extended-nexthop
```

When you specify neighbor swp1 interface..., FRR assumes that you’re using unnumbered BGP, enables RA automatically on that interface, and advertises the capability in the BGP peering session over that interface. 

#### FRR Configuration

```cfg
router bgp 4213010101
  bgp router-id 10.136.128.3
  bgp bestpath as-path multipath-relax
  bgp bestpath compare-routerid
  neighbor FABRIC peer-group
  neighbor FABRIC remote-as external
  neighbor FABRIC bfd 5 200 200
  neighbor swp15 interface peer-group FABRIC
  neighbor swp16 interface peer-group FABRIC
 !
  address-family ipv4 unicast
   redistribute connected route-map rm_LOOPBACK_ONLY
   neighbor FABRIC activate
   exit-address-family
 !
  address-family ipv6 unicast
   redistribute connected route-map rm_LOOPBACK_ONLY
   neighbor FABRIC activate
   exit-address-family
 !
  address-family l2vpn evpn
   neighbor FABRIC activate
   advertise-all-vni
   advertise ipv4 unicast
   advertise ipv6 unicast
   exit-address-family
!
```

`address-family l2vpn evpn` activates EVPN

##### Peer Group

To simplify repetition when configuring multiple neighbors, most routing suites support a form of templating called peer group. The user creates a peer group with a name and then proceeds to configure the desired attributes for neighbor connection (such as remote-as, connection timers, and the use of BFD). In the next step, the operator assigns each real neighbor to the created peer group, thus avoiding the need to type the same boring stuff over and over again.

##### Routing policy

Routing policy, at its simplest, specifies when to accept or reject route advertisements. Based on where they’re used, the accept or reject could apply to routes received from a peer, routes advertised to a peer, and redistributed routes.

A routing policy consists of a sequence of if-then-else statements, with matches and actions to be taken on a successful match.

##### Route Maps

Route maps are a common way to implement routing policies.

```
{# default route maps and prefix lists#}
{{''}}
ip prefix-list pl_DEFAULT_ONLY_4 seq 10 permit 0.0.0.0/0
ip prefix-list pl_DEFAULT_ONLY_4 seq 20 deny any
!
ipv6 prefix-list pl_DEFAULT_ONLY_6 seq 10 permit ::/0
ipv6 prefix-list pl_DEFAULT_ONLY_6 seq 20 deny any
!
route-map rm_DEFAULT_ONLY_4 permit 10
 match ip address prefix-list pl_DEFAULT_ONLY_4
!
route-map rm_DEFAULT_ONLY_4 deny 20
!
route-map rm_DEFAULT_ONLY_6 permit 10
 match ipv6 address prefix-list pl_DEFAULT_ONLY_6
!
route-map rm_DEFAULT_ONLY_6 deny 20
!
route-map rm_LOOPBACK_ONLY permit 10
 match interface lo
!
route-map rm_LOOPBACK_ONLY deny 20
!
```

## Firewalling

The border leaves have interfaces to a firewall. One connection belongs to the green VRF and the other to the black VRF.

![[Pasted image 20210723225803.png]]

The firewalls have two BGP sessions: one over the green subinterface and one over the black interface. The firewall just readvertise the routes learned via the green link to the BGP session over the black link, and vice versa.

Thus, the default route learned by the border router via the internet router is sent to the firewall via the black link. The firewall readvertises this over the green link BGP session. From the perspective of traffic traversing form the internal to the external network, traffic now automatically flows through the firewall.