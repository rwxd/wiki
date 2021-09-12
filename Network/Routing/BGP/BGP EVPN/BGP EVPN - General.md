# BGP EVPN

## What is BGP EVPN?

EVPN is a solution that provides the control plane for network virtualization. In the simplest of terms, EVPN is a technology that connects L2 network segments separated by an L3 network. EVPN accomplishes this by building the L2 network as a virtual Layer 2 network overlay over the Layer 3 network. It uses BGP as its control protocol, and in the data center it uses VXLAN for packet encapsulation.

It relies on multi-protocol BGP (MP-BGP) to exchange information and is based on BGP-MPLS IP VPNs ([RFC 4364](https://tools.ietf.org/html/rfc4364)). The MP-BGP extensions can carry reachability information (NLRI) for multiple protocols (IPv4, IPv6, L3VPN and in our case EVPN). EVPN is a special family to advertise MAC addresses and the remote equipments they are attached to.

It enables not only bridging between end systems in the same layer 2 segment but also routing between different segments (subnets). There is also inherent support for multi-tenancy. EVPN is often referred to as the means of implementing _controller-less VXLAN_.

There are two kinds of reachability information a VTEP sends through BGP EVPN:
1.  the VNIs they have interest in (type 3 routes), and
2.  for each VNI, the local MAC addresses (type 2 routes).

## BGP Constructs to Support Virtual Network Routes

BGP added a few constructs to support advertising virtual network routes. These first arose in the context of MPLS L3VPNs in service provider networks. The first issue is what AFI/SAFI to use. EVPN uses the AFI/SAFI of l2vpn/evpn. This is because EVPN is considered to be a kind of an L2 VPN. Next, BGP must handle the model allowing addresses to be duplicated across virtual networks.

Every BGP implementation I know of maintains two kinds of routing tables: a global one and one per virtual network. BGP runs the best-path algorithm on the global table to pick a single path to advertise for each prefix to its peers. Because the RD is unique to each originator, all copies of a route will be advertised to a neighbor. 

To install routes into a virtual network’s routing table, BGP first uses the import RT clause to select specific candidate routes from the global table to import into this virtual network. Then, it runs the best-path algorithm again on the imported candidate routes, but this time within the context of the virtual network’s routing table. If the same address is advertised with multiple RTs, the best-path algorithm selects the best one. Multiple RTs can be imported into a single virtual network routing table.

### Route Distinguisher

Format of RD for use with EVPN
![[Pasted image 20210725000046.png]]

If you’re wondering how the Virtual Network Instance (VNI) is three bytes long but can be encoded in a two-byte space in the RD, this is not an issue, because it is  assumed that no VTEP will, in practice, host more than 64,000 VNIs.

It is the combination of the router’s IPv4 loopback address plus the VNI that makes the RD unique across the network. Thus, the value of the VNI-specific part of the RD is a device-local encoding of the VNI, not necessarily the absolute value of the VNI.

Because the router’s loopback IP address is part of the RD, two nodes with the same virtual network will end up having different RDs. This solves the problem of distinguishing sources with the same IP address.

The RD is encoded as part of the NLRI in the MP_REACH_NLRI and
MP_UNREACH_NLRI attributes.

### Route Target

RT is an additional path attribute added to virtual network NLRIs. A BGP speaker advertising virtual networks and their addresses uses a specific RT called the export RT. A BGP speaker receiving and using the advertisement uses this RT to decide which local virtual network to add the routes to. This is called the import RT.

Format of RT for use with EVPN-VXLAN:
![[Pasted image 20210725000601.png]]

`ASN` The two-byte ASN of the BGP speaker advertising the address.

`A` A bit indicating whether the RT is autoderived or manually configured.

`Type` A three-bit field indicating the encapsulation used in EVPN. For VXLAN, it is 1, and for VLAN, it is 0.

`Domain-ID (D-ID)` Four bits that are typically zero. In certain cases, if there is an overlap in the VXLAN numbering space, this field is used to qualify the administrative domain to which the VNI belongs.

`Service ID` Three bytes containing the virtual network identifier. For VXLAN, it is the 3-byte VNI; for VLAN it is 12 bits (the lower 12 bits of the 3-byte field).

### Route Types
![[EVPN Route Types]]

![[EVPN and Bridging]]

![[ARP ND Suppresion]]

![[Route Advertisements]]

[[BGP - General]]


