# What is VXLAN?


VXLAN (Virtual Extensible LAN) is a standard overlay protocol that abstracts logical virtual networks from the physical network underneath. You can deploy simple and scalable layer 3 Clos architectures while extending layer 2 segments over that layer 3 network. The tunnel edges are called VTEPs (VXLAN Tunnel Endpoints)

![[Pasted image 20210723194116.png]]

VXLAN uses a VLAN-like encapsulation technique to encapsulate MAC-based layer 2 Ethernet frames within layer 3 UDP packets Each virtual network is a VXLAN logical layer 2 segment. VXLAN scales to 16 million segments - a 24-bit VXLAN network identifier (VNI ID) in the VXLAN header - for multi-tenancy.

![[Pasted image 20210723221403.png]]

In a large VXLAN deployment, two aspects need attention:
1. discovery of other endpoints (VTEPs) sharing the same VXLAN segments
2. avoidance of BUM frames (broadcast, unknown unicast and multicast) as they have to be forwarded to all VTEPs.

Each VXLAN is locally configured using a bridge for local virtual interfaces, like illustrated in the below schema. The bridge is taking care of the local MAC addresses (notably, using source-address learning) and the VXLAN interface takes care of the remote MAC addresses (received with BGP EVPN).

![[Pasted image 20210723211203.png]]

[[BGP EVPN - General]]