![[Pasted image 20210723235251.png]]

The workhorse BGP message is Update, which carries the list of advertised routes and the list of withdrawn routes. BGP uses the term Network Layer Reachability Information (NLRI) to mean the advertised routes. Communities are encoded in the “Path Attributes List” section.

![[Pasted image 20210723235409.png]]

A single BGP Update message can carry information about more than one AFI/SAFI. For example, a single BGP update message can carry updates for both IPv4 and IPv6.