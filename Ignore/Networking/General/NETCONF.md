# Overview

Provides a standard connection protocol to communicate with network devices.

![[Pasted image 20210724195536.png]]

# Layers

## Messages Layer

### `<rpc>` 
	
-   The `<rpc>` element encapsulates all remote procedure calls to the NETCONF server.
-   This includes both operational mode and configuration RPCs.

	
### `<rpc-reply>`

-   The `<rpc-reply>` element encapsulates all remote procedure call replies from the NETCONF server.
-   This includes data returned from the NETCONF server and any 0K. error or warning messages.

### `<notification>`

-   The `<notification>` element is a one-way message and is sent to the client who initiated a `<create-subscription>` command when an event of interest has occurred.

## Operations Layer

```xml
<lock>
<unlock>
<get>
<get-config>
<edit-config>
<copy-config>
<commit>
<discard-changes>
<delete-config>
<validate>
<create-subscription>
<close-session>
<kill-session>
```

## Content Layer

-   Contains RPC request and response payload
-   Contains configuration data