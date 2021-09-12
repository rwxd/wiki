# NSX-T Edge Technology

Edge Nodes are simply ‘service appliances’ that provide pools of capacity and are reserved to running network services that are not distributed down to the hypervisors. They provide the physical network uplinks (pNICs) that connect to the physical network (underlay). NSX-T provides two types of Edge Nodes: bare metal edge and VM edge.

Edge Clusters are a group of Edge Transport nodes that provide a scalable, high-throughput and highly available (redundant) gateway for logical networks created in NSX-T. More on clusters in a minute.

## Bare Metal Edge vs VM Edge

### Deployment

- Bare metal edge nodes are deployed on a physical server and deployed via ISO or PXE boot. The NICs on the bare metal edge requires support for DPDK (reference the compatibility guide for more information).

- VM edge node is deployed using OVA/OVF or ISO file and only supported on an ESXi host (not KVM).

### Performance

- Bare Metal Edge provides sub-second convergence, rapid fail over and higher throughput with low packet size.
    - dedicated interface (NIC) for management (secondary interface can be used for management HA and can also be 1 Gbps). This management network cannot run on a Fast Path interface.
    - Supports a maximum of 16 physical network uplinks for both overlay and external traffic; pNICs connected to ToR switching.
    - Supports in-band management (Fast Path) meaning the management traffic can utilize an interface used by overlay or external network traffic (N-S traffic).
    - Each pNIC (16) has an internal interface that is assigned to the DPDK (Data Plane Development Kit) Fast Path. There is flexibility when assigning the "Fast Path interfaces" to overlay or VLAN backed connectivity.
    - Fast Path NICs – up to four dedicated to the data path using DPDK for high performance; external networks and the overlay use these NICs.

- The Edge VM contains four internal interfaces (vNICs). Management is reserved on "eth0" whereas DPDK Fast Path is assigned to interfaces "fp-eth0, fp-eth1 and fp-eth2" which are assigned to external connectivity for NSX-T overlay traffic (TEP traffic) and ToR switching.
    -   One vNIC for management.
    -   One vNIC for overlay traffic.
    -   Two vNICs for external traffic.

## Edge Clusters

An Edge Cluster is simply a group of Edge transport nodes.
Scale out capabilities for logical networks to the Edge nodes is accomplished via ECMP (Equal Cost Multi-Pathing). Tier-0 and Tier-1 gateways can be hosted on the same Edge Cluster or separate Edge Clusters.

Scale out capabilities for logical networks to the Edge nodes is accomplished via ECMP (Equal Cost Multi-Pathing). Tier-0 and Tier-1 gateways can be hosted on the same Edge Cluster or separate Edge Clusters.

Dependent upon the requirements for your network design, the Edge cluster could be "dedicated" to providing centralized such as NAT. Below is a list of some requirements / limitations on the Edge Clusters:

- There is a maximum of ten edge nodes that can be grouped together in a single Edge Cluster.
- Edge nodes run BFD (Bidirectional Forward Detection) on both the management and tunnel networks in order to detect Edge Node failures. This fast detection of failure improves convergence.
    - VMs support BFD with a minimum of one second on the BFD timer with three retries = three second failure detection.
    - Bare metal edges support BFD with minimum of 300ms (BDF Tx/Rx timer) with three retries = 900ms failure detection.
- Only one Tier-0 gateway per Edge node; multiple Tier-1 gateways can be hosted per Edge node.
    - Tier-0 gateway supports a maximum of eight equal cost paths which means there is a maximum of eight Edge nodes for ECMP.

[[Single Tier Routing]] [[Two Tier Routing]]

## Edge Bridge

In the event you have VMs that are connected to a logical network in the NSX-T overlay, an admin can configure a "bridge-backed logical switch" that will provide Layer 2 connectivity with other VMs or physical devices that are "outside" the NSX-T overlay.

## Failure Domain

The Failure Domain is a logical grouping of Edge Nodes within an existing Edge Cluster. The benefit here is to help guarantee service availability of a Tier-1 SR (Service Router) ensuring the active and standby instances do not run in the same failure domain (i.e. same rack).