# What is Single-tier routing?
Single-tier routing is a NSX-T Tier-0 gateway that provides both distributed routing and centralized routing along with other services such as NAT, DHCP, load balancers and so on. The segments (subnets) in a single-tier topology are connected directly to the NSX-T gateway. VMs connected to these segments can communicate East-West as well as North-South to the external data center.

There is a distributed routing (DR) component for this T0 gateway; this instance is created as a kernel module and will function as a ‘local gateway’ for the workloads connected to these segments. There is a logical interface (LIF) on the gateway that is used as the default gateway. Apply the gateway for the L2 segment, configure your VMs properly and traffic will begin to flow as expected.

There are two distinct NSX-T components…the DR (distributed router) and SR (services router). In vSphere, the ESXi host(s) have the DR component only whereas the Edge Node(s) have a merged DR/SR component.

![[Pasted image 20210726085859.png]]

East-West routing is distributed by the hypervisor (aka host transport node); each hypervisor in the TZ is running a DR at the kernel level. When they are created they exist on the edge node as an SR and not distributed as a DR. Below is a list of some of the SR services that can be enabled in NSX-T:
-   Gateway Firewall
-   DHCP
-   VPN
-   NAT
-   Bridging
-   Service Interface
-   Physical network connectivity
-   Metadata Proxy