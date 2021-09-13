BGP also allows user-extensible grouping of routes via an attribute called communities. Communities are transitive optional attributes. Communities are used by operators to group together a set of advertised routes to apply a routing policy to. A routing policy influences the semantics of BGP Update message processing and best path computation for those routes.

A single Update message can carry multiple communities. Communities are four-byte values, not arbitrary text strings. The first two bytes are always the ASN of the BGP speaker that originated the community, whereas the remaining two bytes are left up to the network operators to use as they want.

Network virtualization routing information with two-byte ASNs uses extended communities, whereas the information with four-byte ASNs uses large
communities.
