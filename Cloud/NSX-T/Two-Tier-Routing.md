# What is Two Tier Routing?
With two-tier routing, you will find both T0 and T1 gateways (virtual routers). The T0 gateway is common referred to as the ‘provider’ and the T1 would be the ‘tenant’. This design enables provider admins and tenant admins total control over their services and policies because they operate separately from one another.

The T0 gateway handles all northbound traffic and can connect with one or more physical routers and/or L3 switches. Southbound T0 traffic traverses something called a ‘RouterLink interface’ which established between the T0 and T1 gateways. The T1 gateway has northbound connectivity to the T0 gateway through this interface and then southbound interface(s) are called ‘downlinks’ which are from the T1 gateway to one or more L2 segments. T1 routers cannot connect directly to the physical underlying infrastructure, only T0 routers can provide connectivity to the physical network commonly referred to as the underlay.

The concepts of distributed routers (DR) and service routers (SR) are no different than with single-tier routing. One area that is different in this topology compared to single-tier is the use of the RouterLink Interface (Linked Port) which is used to connect T0 and T1 gateways. A peer connection is established using the 100.64.0.0/16 reserved address space (RFC 6598). It will appear in the configuration as a /31 subnet which you may see during the step-by-step exercise when establishing the connectivity between T0 and T1.

This connectivity is entirely ‘auto-plumbed’ into the configuration and therefore no dynamic routing is required between T0 and T1.

The fully distributed routing architecture of NSX-T is intended to provide routing functionality closest to the source; capable of extending it to multiple tiers. NSX-T supports both static routing as well as dynamic routing through the use of BGP on the T0 gateways. The T1 gateways support static routes but do not support any dynamic routing capabilities. This is were effective NSX-T Route Redistribution will come into play.