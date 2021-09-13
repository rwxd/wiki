# EVPN Route Advertisements
An EVPN RT-2 advertisement contains the IP address associated with a {MAC, VNI} tuple. This information is used to populate the routing table. But there are cases for which we need a summarized route or a route to be advertised that has been learned as an IP route. Consider where the routing table needs to be populated with the default route that leads to the outside world. Typically, the exit leaves advertise this route. A new route type, RT-5, was introduced to advertise IP routes. IP routes are not advertised automatically; they must be configured. **IP routes are always advertised with an L3 VNI. Every device maps the L3 VNI to a local VRF before populating the routing table.**

There are three additional pieces of information required for symmetric routing: the VNI to use between the ingress and egress VTEPs, the next-hop IP address (which is the egress VTEP’s IP address), and the router MAC address of the egress VTEP. These need to be conveyed in some BGP UPDATE message. The egress VTEP’s IP address is always carried in the NEXTHOP attribute of the BGP advertisement. The RT-2 mes‐ sage has provisions allowing it to carry the other two pieces of information.

The route also needs to carry the egress VTEP’s MAC address, because this address is used as the destination MAC address on the inner packet. This MAC address is carried as a new BGP Extended Community in the advertisement. This new extended community is called the Router MAC Extended Community.

## The Use of VRFs

In EVPN, routing is assumed to occur within the context of a VRF. The underlay
routing table is assumed to be in the default or global routing table, whereas the overlay routing table is assumed to be in a VRF-specific routing table.

RT-5 advertisements always occur in the context of a VRF: the L3 VNI signaled in the advertisement. Thus, to preserve a uniform routing model, I strongly recommend always using VRFs with EVPN routing.


[[EVPN Route Types]]