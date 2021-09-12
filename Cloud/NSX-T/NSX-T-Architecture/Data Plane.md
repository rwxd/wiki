# NSX-T Data Plane

The data plane is where all stateless forwarding takes place based on tables created by the control plane. Packet level stats are found here as well as topology information which is then reported from the data plane up to the control plane.

In the data plane are the NSX-T transport nodes which are hosts running the LCP daemons and forwarding engines.

## N-VDS (NSX Virtual Distributed Switch)

N-VDS is a basic software-defined switch platform that is completely hypervisor independent. It is responsible for forwarding network traffic between the components on the transport node (virtual machines) or between the internal components and the underlying physical network.

The N-VDS is required when implementing an overlay in NSX-T and can therefore co-exist with a VDS (Virtual Distributed Switch)

The N-VDS must have at least one or more physical network interfaces (aka pNIC). The N-VDS cannot share a pNIC with another N-VDS. So when you assign a pNIC to a N-VDS it stays with that N-VDS. Several N-VDS can co-exist provided each N-VDS is using it's own set of pNIC(s).

### Uplinks & pNICs

A pNIC is the actual physical network port on a transport node and an uplink is used in software on the N-VDS to define how the pNIC will be used.


#### Uplink Profiles

Uplink Profiles are used as a "template" to define how an N-VDS will connect to the physical network and ensures the profile is applied consistently across multiple transport nodes (ESXi or KVM hypervisors).
![[Pasted image 20210722224252.png]]

## Teaming Policy

The teaming policy defines how the NSX virtual switch uses its uplinks for redundancy and traffic load balancing. It only defines how the NSX virtual switch balances traffic across its uplinks.

![[Pasted image 20210726161506.png]]

### Failover Order

An active uplink is specified along with an optional list of standby uplinks. Should the active uplink fail, the next available uplink in the standby list takes its place immediately.

### Load Balanced Source Port / Load Balance Source Mac Address

Traffic is distributed across a specified list of active uplinks.

#### Load Balanced Source Port

The "Load Balanced Source Port" policy maps a virtual interface to an uplink of the host. Traffic sent by this virtual interface will leave the host thorough this uplink only, and traffic destined to this virtual interface will necessarily enter the host via this uplink.

#### Load Balanced Source MAC Address

The “Load Balanced Source Mac Address” goes a little bit further in term of granularity for virtual interfaces that can source traffic from different mac addresses: two frames sent by the same virtual interface could be pinned to different host uplinks based on their source mac address.

## Edge Nodes

Edge Nodes are "service appliances" which are dedicated to running network services that are not dispersed to the hypervisors (ESXi or KVM). They represent a pool of capacity and can be grouped in one cluster or across several clusters.


## Hypervisor Transport Nodes

Hypervisor Transport Nodes are simply hypervisors (ESXi or KVM) that have been 
prepared and configured to run on NSX-T.

## L2 Bridge

L2 Bridge is a virtual appliance that is used to bridge traffic between an NSX-T overlay and a traditional VLAN backed physical network. This bridge is deployed through a cluster of two ESXi hosts dedicated for bridging purposes (active/standby on a per-VLAN basis).