A BGP router computes the best path for each advertised route, starting from itself. BGP’s best-path selection is triggered when a new UPDATE message is received from one or more of its peers. BGP advertises a route only if the computation changes (adds, deletes, or updates) the best path for a given 
network destination.

![[Pasted image 20210723234810.png]]

In other words, a prefix that is local to a node is preferred to one learned via BGP, and a shorter AS_PATH length route is preferred over a route with a longer AS_PATH length. If the AS_PATH lengths are equal, the paths are considered equal cost. In reality, the default BGP implementation not only requires the AS_PATH lengths to be the same to be considered equal cost, but the individual ASNs in the AS_PATH must be identical. You need to turn on a knob that relaxes this restriction and only uses the AS_PATH length in determining equal cost.