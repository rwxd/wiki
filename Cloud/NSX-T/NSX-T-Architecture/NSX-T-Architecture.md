# NSX-T Architecture

```plantuml
!theme amiga

package management as "Management Plane" {
	node manager as "NSX-T\nManager"
	collections vcenters as "multiple\nvCenters"
	
	manager -right-> vcenters
}
package control as  "Control Plane" {
	collections controcluster as "NSX-T Controller Cluster"
}
package data as "Data Plane" {
	package privatecloud as "Private Cloud"{
		package hypervisors as "Hypervisors"{
			node ESXi
			node KVM
		}
		node edge as "Edge VM or\nBare-metal"
	}
	package publiccloud as "Public Cloud"{
		node cloud_gateway as "NSX Cloud Gateway"
		node vmware_awx as "VMware on AWS"
	}
}

management -[hidden]down- control
control -[hidden]down- data
```

![[Pasted image 20210722153255.png]]

![[Management-Plane]]

![[Control Plane]]

![[Data Plane]]

![[Transport-Zones]]

![[Edge Technology]]

![[NSX-T-Profiles]]

![[Single-Tier-Routing]]

![[Two-Tier-Routing]]

[Single-Tier-Routing](Single-Tier-Routing.md)