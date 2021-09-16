
# Deploy VXLAN & EVPN with FRR

Topology used:
![[Pasted image 20210725194142.png]]

## Local Configuration
### leaf01

```json
auto all
iface lo inet loopback
	address 10.0.0.11/32
	clagd-vxlan-anycast-ip 10.0.0.112
	vxlan-local-tunnelip 10.0.0.11

iface vni13
	mtu 9164
	vxlan-id 13
	bridge-access 13
	bridge-learning off
	
iface vni24
	mtu 9164
	vxlan-id 24
	bridge-access 24
	bridge-learning off

iface vlan13
	mtu 9164
	address 172.16.1.11/24
	address-virtual 44:39:39:ff:00:13 172.168.1.1/24
	vlan-id 13
	vlan-raw-device-bridge
	vrf evpn-vrf

iface vlan24
	mtu 9164
	address 172.16.2.11/24
	address-virtual 44:39:39:ff:00:13 172.168.2.1/24
	vlan-id 24
	vlan-raw-device-bridge
	vrf evpn-vrf

# This is the L3 VNI definition that we need for symmetric configuration.
# This is used to transport the EVPN-routed packet between the VTEPs.

iface vxlan4001
	vxlan-id 104001
	vlan-raw-device-bridge
	
iface vlan4001
	hwaddress 44:39:39:FF:40:94
	vlan-id 4001
	vlan-raw-device-bridge
	vrf evpn-vrf
```

`clagd-vxlan-anycast-ip 10.0.0.112` configures the Cumulus-specific MLAG implementation, CLAG, by defining the shared VXLAN source tunnel's IP address. This is required because of the dual-attached servers.

`vxlan-local-tunnelip 10.0.0.11` specifies the local source tunnel IP address to be used when CLAG isn't operational. When CLAG is operational, the address specified with `clagd-vxlan-anycast-ip` is used as the tunnel source IP address.

`iface vni 13` each VXLAN VNI is represented by a device in the Linux kernel.

`mtu 9164` VXLAN tunnel interfaces recommend using jumbo frames, so we set the MTU of the interface to 9164

`bridge-access` maps the VNI to a local VLAN ID

`bridge-learning off` because we don't want to enable learning of remote MAC addresses because we have EVPN. So we disable learning on the VNIs

`iface vlan13` this defines the SVI for the VNIs - these are the VNIs for which the node supports routing

`address 172.16.1.11/24` the unique IP address of this leaf on the specified VNI

`address-virtual 44:39:39:ff:00:13 172.168.1.1/24` this is the secondary gateway IP address for the VNI. The address is shared across all the leaves that carry this VNI. Servers are configured to use this IP address as the default gateway address to allow a server to be attached to any rack and not have to change its default gateway configuration

`vlan-raw-device-bridge` Linux allows the presence of multiple 802.1Q bridges on the same device. An interface is assigned to only one of the bridges and so there is no ambiguity on the link about the use of a VLAN.

`iface vxlan4001` this is the L3 VNI used in symmetric routing

`iface vlan4001` this is merely the local instantiation of the L3 VNI

### exit01

```
interface lo
	ip address 10.0.0.101/32
!
interface swp3
	ip address 169.254.127.1/31
!
interface swp4.2
	ip address 169.254.254.1/31
!
interface swp4.3
	ip address 169.254.254.3/31
!
interface swp4.4
	ip address 169.254.254.5/31
!
vrf evpn-vrf
	vni 104001
!
! default VRF peering with the underlay and the firewall
```

## Single eBGP Session

### spine01

```
interface lo
	ip address 10.0.0.21/32
!
router bgp 65000
	bgp router-id 10.0.0.21
	bgp bestpath as-path multipath-relax
	neighbor peer-group ISL
	neighbor ISL remote-as external
	neighbor swp1 interface peer-group ISL
	neighbor swp2 interface peer-group ISL
	neighbor swp3 interface peer-group ISL
	neighbor swp4 interface peer-group ISL
	neighbor swp5 interface peer-group ISL
	neighbor swp6 interface peer-group ISL
	address-family ipv4 unicast
		neighbor ISL activate
		redistribute connected route-map LOOPBACKS
	address-family l2vpn evpn
		neighbor ISL activate
!
route-map LOOPBACKS permit 10
	match interface lo
```

`address-family l2vpn evpn` activates the l2vpn evpn address family to signal to its peers that it can process EVPN routes. This is not an indication that the spine is participating in the overlay. Required on all nodes that exchange EVPN information.

### leaf01

```
interface lo
	ip address 10.0.0.11/32
!
! This VRF definition is needed only for symmetric EVPN routing
vrf evpn-vrf
	vni 104001
!
router bgp 65011
	bgp router-id 10.0.0.11
	bgp bestpath as-path multipath-relax
	neighbor fabric peer-group
	neighbor fabric remote-as external
	neighbor swp1 interface peer-group fabric
	neighbor swp2 interface peer-group fabric
	address-family ipv4 unicast
		neighbor fabric activate
		redistribute connected route-map LOOPBACKS
	!
	address-family l2vpn evpn
		neighbor fabric activate
		advertise-all-vni
	advertise-svi-ip
	!
!
route-map LOOPBACKS permit 10
	match interface lo
!
```

`vrf evpn-vrf` this VRF definition is what distinguishes symmetric routing configuration from asymmetric routing in the configuration. This definition specifies the L3 VNI used by a VRF. Think of this mapping as the equivalent of the VLAN-VNI mapping.

`advertise-all-vni` enables advertisement of EVPN information, specifically RT-2 and RT-3 routes. This is present only on leaves (border or normal).

`advertise-svi-ip` needed for individual leaves to run `ping, traceroute` from the leaves on the evpn-vrf.



### exit01

```
router bgp 65201
	bgp router-id 10.0.0.101
	bgp bestpath as-path multipath-relax
	neighbor fabric peer-group
	neighbor fabric remote-as external
	! These two are peering with the spine
	neighbor swp1 interface peer-group fabric
	neighbor swp2 interface peer-group fabric
	! This is peering with the firewall to announce the underlay
	! routes to the edge router (via the firewall) and receive the
	! default route from the edge router (also via the firewall)
	neighbor swp4.2 interface remote-as external
	address-family ipv4 unicast
		neighbor fabric activate
	neighbor swp4.2 activate
		neighbor swp4.2 allowas-in 1
		redistribute connected route-map LOOPBACKS
	!
	address-family l2vpn evpn
		neighbor fabric activate
		advertise-all-vni
	!
!
route-map LOOPBACKS permit 10
	match interface lo
!
! evpn vrf peering to announce default route to internal net
!
router bgp 65201 vrf evpn-vrf
	bgp router-id 10.0.0.101
	neighbor swp4.3 interface remote-as external
	address-family ipv4 unicast
		neighbor swp4.3 activate
		! The following two network statements are for
		! distributing the summarized route to the firewall
		aggregate-address 172.16.1.0/24 summary-only
		aggregate-address 172.16.2.0/24 summary-only
		neighbor swp4.3 allowas-in 1
		exit-address-family
	!
	! This config ensures we advertise the default route
	! as a type 5 route in EVPN in the main BGP instance.
	! The firewall peering is to get the default route
	! in the evpn-vrf from the internet-vrf. Firewall
	! does not peer for l2vpn/evpn.
	!
	address-family l2vpn evpn
		advertise ipv4 unicast
!
! internet vrf peering to retrieve the default route from the
! internet facing router and give it to the firewall.
!
router bgp 65201 vrf internet-vrf
	bgp router-id 10.0.0.101
	bgp bestpath as-path multipath-relax
	neighbor internet peer-group
	neighbor internet remote-as external
	neighbor swp4.4 interface peer-group internet
	neighbor swp3 interface peer-group internet
	address-family ipv4 unicast
		neighbor internet activate
		neighbor swp4.4 allowas-in 1
	neighbor swp3 remove-private-AS
		redistribute connected route-map INTERNET
	!
!
route-map INTERNET permit 10
	match interface internet-vrf
!

```

`router bgp 65201` this section deals with the underlay and the receiving of EVPN routes from the rest of the leaves. It also peers with the firewall to ensure that the underlay gets the default route.

`router bgp 65201 vrf evpn-vrf` this VRF configuration on the exit leaf is required to advertise the default route in the evpn-vrf VRF.

`aggregate-address 172.16.1.0/24 summary-only` instructs BGP to announce only the summarized route and do so only if there's at least one route in that subnet.

`address-family l2vpn evpn` advertises the default route as an RT-5 EVPN route. No activate statement is required, because there are no neighbors with whom EVPN routes are to be exchanged in this VRF. The RT-5 route is announced in the underlay BGP session.

`router bgp 65201 vrf internet-vrf` VRF configuration to interface with the edge route in the internet-vrf for connectivity to the outside world. The internet-vrf has no EVPN configuration, so there is no need to define an L3 VNI for the internet-vrf.

`neighbor swp3 remove-private-AS` strips off all private ASNs before advertising the routes to the edge router.

When VXLAN is the virtual network overlay, BGP doesn't require any per-VRF peering, because the VNI in the packet encodes this information.

## VXLAN Setup

Each VXLAN is locally configured using a bridge for local virtual interfaces, like illustrated in the below schema. The bridge is taking care of the local MAC addresses (notably, using source-address learning) and the VXLAN interface takes care of the remote MAC addresses (received with BGP EVPN).

![[Pasted image 20210723211203.png]]

VXLANs can be provisioned with the following script. Source-address learning is disabled as we will rely solely on BGP EVPN to synchronize FDBs between the hypervisors.

```
for vni in 100 200; do
    # Create VXLAN interface
    ip link add vxlan${vni} type vxlan
        id ${vni} \
        dstport 4789 \
        local 203.0.113.2 \
        nolearning
    # Create companion bridge
    brctl addbr br${vni}
    brctl addif br${vni} vxlan${vni}
    brctl stp br${vni} off
    ip link set up dev br${vni}
    ip link set up dev vxlan${vni}
done
# Attach each VM to the appropriate segment
brctl addif br100 vnet10
brctl addif br100 vnet11
brctl addif br200 vnet12
```


The configuration of _FRR_ is similar to the one used for a route reflector, except we use the `advertise-all-vni` directive to publish all local VNIs.

```
router bgp 65000
  bgp router-id 203.0.113.2
  no bgp default ipv4-unicast
  neighbor fabric peer-group
  neighbor fabric remote-as 65000
  neighbor fabric capability extended-nexthop
 ! BGP sessions with route reflectors
  neighbor 203.0.113.253 peer-group fabric
  neighbor 203.0.113.254 peer-group fabric
 !
  address-family l2vpn evpn
   neighbor fabric activate
   advertise-all-vni
 exit-address-family !
!
```

FRR should also be able to retrieve information about the local MAC addresses. Each VTEP has to establish a BGP session with the route reflectors.

# BGP EVPN (Ethernet Virtual Private Network)




### Route reflector setup using FRR

The configuration is pretty simple. We suppose the configured route reflector has `203.0.113.254` configured as a loopback IP.
```json
router bgp 65000
  bgp router-id 203.0.113.254
  bgp cluster-id 203.0.113.254
  bgp log-neighbor-changes
  no bgp default ipv4-unicast
  neighbor fabric peer-group
  neighbor fabric remote-as 65000
  neighbor fabric capability extended-nexthop
  neighbor fabric update-source 203.0.113.254
  bgp listen range 203.0.113.0/24 peer-group fabric
 !
  address-family l2vpn evpn
   neighbor fabric activate
   neighbor fabric route-reflector-client
  exit-address-family
 !
!
```

A peer group `fabric` is defined and we leverage the dynamic neighbor feature of FRR: we don’t have to explicitly define each neighbor. Any client from `203.0.113.0/24` and presenting itself as part of AS 65000 can connect. All sent EVPN routes will be accepted and reflected to the other clients.

### Using Junos

```json
interfaces {
    lo0 {
        unit 0 {
            family inet {
                address 203.0.113.254/32;
            }
        }
    }
}

protocols {
    bgp {
        group fabric {
            family evpn {
                signaling {
                    /* Do not try to install EVPN routes */
                    no-install;
                }
            }
            type internal;
            cluster 203.0.113.254;
            local-address 203.0.113.254;
            allow 203.0.113.0/24;
        }
    }
}

routing-options {
    router-id 203.0.113.254;
    autonomous-system 65000;
}
```

## ARP suppression