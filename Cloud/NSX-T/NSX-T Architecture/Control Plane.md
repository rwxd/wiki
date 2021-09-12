# NSX-T Control Plane

The control plane is responsible for calculating the "run-time state" of the systems based on the configuration provided by the NSX-T Manager (management plane).

It also communicates with the data plane and therefore is responsible for distributing topology information and pushing stateless configuration information to the forwarding engines.

## CCP (Central Control Plane)

The CCP employs cluster of VMs called CCP nodes. The cluster provides redundancy and scalability. User traffic does not traverse the CCP cluster.

## LCP (Local Control Plane)

The LCP is found on the transport nodes which use the LCP to connect and communicate with the CCP. The programming for the forwarding entries occurs here.

```plantuml
node test1
node test2

test1 -> test2
```