# VXLAN General

VXLAN (Virtual Extensible LAN) is a standard overlay protocol that abstracts logical virtual networks from the physical network underneath. With VXLAN simple and scalable layer 3 Clos architectures can be deployed, while extending layer 2 segments over that layer 3 network. VTEPs (VXLAN Tunnel Endpoints) are the tunnel edges. 

VXLAN uses a VLAN-like encapsulation technique to encapsulate MAC-based layer 2 Ethernet frames within layer 3 UDP packets Each virtual network is a VXLAN logical layer 2 segment. VXLAN scales to 16 million segments - a 24-bit VXLAN network identifier (VNI ID) in the VXLAN header - for multi-tenancy.

In a large VXLAN deployment, two aspects need attention:
1. discovery of other endpoints (VTEPs) sharing the same VXLAN segments
2. avoidance of BUM frames (broadcast, unknown unicast and multicast) as they have to be forwarded to all VTEPs.

On [[about-cumulus-linux|Cumulus Linux]] each VXLAN is locally configured using a bridge for local virtual interfaces. The bridge is taking care of the local MAC addresses (notably, using source-address learning) and the VXLAN interface takes care of the remote MAC addresses (received with BGP EVPN).
