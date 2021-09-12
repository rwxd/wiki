# ARP/ND Suppression

ARP requests and gratuitous ARP (GARP) packets are BUM packets because these packets are sent to the broadcast address.

A leaf can cache a server’s ARP / ND information and respond directly. This has the good effect of reducing BUM traffic in the network. This function of caching a remote host’s ARP/ND information and responding to ARP/ND requests for this information is ARP/ND suppression.

ARP/ND suppression uses RT-2 messages to convey the IP address associated with a MAC address in a virtual network.

It is up to the implementation to decide whether it wants to send separate MAC and MAC/IP advertisements or use a single message for both. FRR uses a single message update model when ARP/ND suppression is enabled.

The kernel does not attempt to run ARP refresh for such entries. The kernel also does not age out entries that have been marked as learned via a control protocol. The protocol is responsible for removing these entries when the remote entries, advertisements are withdrawn. FRR also removes them on graceful shutdown or on recovery from a crash.

