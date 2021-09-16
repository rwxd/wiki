![[Pasted image 20210723194914.png]]

RR follows a hub-and-spoke model, in which all the iBGP speakers connect to a
group of central RR servers. The job of the RRs is to compute the best path for a route and advertise that to each of the RR clients. However, unlike eBGP, the RR doesn’t modify the next-hop network address for a route; instead, it leaves it to be whatever the value was in the advertisement that the RR received.

In the case of eBGP, the next hop is always modified to be the advertising router. This is called next-hop self. In case of iBGP, the next hop associated with a route is not modified when advertised to a peer.