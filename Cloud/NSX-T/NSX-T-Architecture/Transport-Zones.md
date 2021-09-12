# NSX-T Transport Zones

## About Transport Zones

Transport Zones (TZ) are used to define a group of ESXi hosts that can communicate with one another on a physical network. This communication takes place between the TEPs (Tunnel End-Points) which are vmkernel adapters on the transport node(s) in the TZ. A Transport Zone is a way to logically define one or more host clusters that will be used to provide NSX-T networking. They are virtual Layer 2 Domains (segments).

There are two types of transport zones: Overlay or VLAN. You can pick one or the other but not both when planning the transport zone.

## Important information for Transport Zones

- The NSX-T environment can contain one or more TZs. You must provide a name for the N-VDS that will be installed on the transport nodes (they will be added later to the TZ).

- A host can belong to multiple transport zones but a logical switch can only belong to one TZ. Therefore the span (or area) of a logical switch is limited to the transport zone.

- Overlay TZs are used by both the NSX Edges and the Host Transport Nodes. When the environment scales and a Host TN or NSX Edge node is added to an overlay TZ the N-VDS is installed on that host tn or NSX Edge.

- VLAN TZs are used by the NSX Edge for the VLAN uplinks. Anytime an NSX Edge is added to this type of transport a VLAN N-VDS is installed on the NSX Edge.

The NVD-S is responsible for transmitting "virtual-to-physical" network packet flow by joining logical router uplinks with physical NIC downlinks essentially binding the virtual and physical worlds together. This is why planning the Uplink Profiles is important because it is describing how you want network traffic to communicate between the virtual and physical layers.

## Important restrictions for Transport Zones

- A N-VDS can be attached to an Overlay TZ and VLAN TZ simultaneously whereby the N-VDS name will be the same.

- A N-VDS can only append to a single VLAN TZ but a transport node can append to multiple VLAN TZs with multiple N-VDS.

- A N-VDS can only append to a single Overlay TZ.

- Multiple N-VDS and traditional VDS can co-exist but a pNIC (physical port) can only be associated with one or the other. The pNIC cannot be associated with a N-VDS and VDS.

- A transport node can append to a single Overlay TZ. Consequently, only a single N-VDS can attach to an Overlay TZ on that transport node.

## What’s the difference between VLAN backed and Overlay TZs?

A VLAN backed TZ (segment) is a ‘layer 2 broadcast domain’ and is applied as a VLAN on the traditional physical infrastructure. What this means is the network communication between two VMs residing on separate hosts and attached to the same VLAN network (i.e. VLAN 101 – 192.168.101.x /24 network) will be transmitted over the VLAN between the two hosts. The one constraint (requirement) here is that VLAN must be provisioned (presented) to both hosts in order for those two VMs to communicate over that VLAN backed TZ (segment).

In an Overlay TZ (segment), these same two VMs running on different hosts will have their Layer 2 transmission between the ‘tunnel’ that exists between the two transport nodes (hosts). This tunnel is an IP-based tunnel endpoint (TEP); this instance is maintained by NSX without the reliance for any segmented network configuration from the physical infrastructure. This type of TZ is where the physical network is truly "decoupled" by NSX.