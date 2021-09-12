# NSX-T Profiles

## About NSX-T Profiles

Profiles in NSX-T are very useful and are used to ensure consistent configurations are propagated to the transport nodes. Just another way NSX-T reduces configuration complexity during post deployment steps as you prepare the environment for NSX-T.

## Uplink Profile

Defines how the uplinks for the transport nodes should be configured. Here you can configure how LAGs should be configure (if you plan on using them) along with the LACP mode, LACP Load Balancing method, number of uplinks (2 minimum) and LACP timeout options. "Teamings" will define how you want your uplinks to behave by defining the Teaming Policy, Active Uplinks and Standby Uplinks.

## NIOC Profile

Defines how to carve up bandwidth for the types of traffic. If you are familiar with how NIOC was configured on a vDS, this is really not that much different. You can specify different share values, impose limits (%) as well as reservations (%) which will guarantee specific bandwidth to traffic at all times.

## Edge Cluster Profiles

used to define how BFD (Bidirectional Forward Detection) will be applied on the Edge Cluster that services your environment. Here you can apply BFD Probe Internal (ms), PFD Allowed Hops, BFD Declare Dead Multiple and Standby Relocation Threshold (minutes).

## Edge Bridge Profile

Describes how an Edge Cluster can provide Layer 2 bridging capabilities between NSX-T and a logical switch that is backed by a traditional VLAN.

## Transport Node Profile

This profile has everything including which Transport Zone(s) you want the Node Profile to apply to, how the N-VDS should be deployed as well as associate other profiles to the transport node including NIOC Profile, Uplink Profile, LLDP Profile and so on. Here you can also configure Network Mappings for Installation and Uninstall which is useful when migrating your existing networks over to the N-VDS (including pNIC migration).