# Linux Network Namespaces

## Overview

Linux Network Namespaces provide a powerful and flexible way to isolate network resources within the Linux operating system. This feature allows you to create multiple independent network stacks, each with its own set of network interfaces, routing tables, and firewall rules. Network namespaces are particularly useful for scenarios where you need to create isolated network environments, such as in testing, debugging, or containerization.

## Key Concepts

### 1. Network Namespace

A network namespace is an isolated instance of the network stack. It includes its own set of network interfaces, IP addresses, routing tables, and firewall rules. By default, a Linux system has a single global network namespace, and additional namespaces can be created as needed.

### 2. ip netns command

The ip netns command is the primary tool for managing network namespaces. It allows you to create, delete, and list namespaces. Additionally, it provides a way to execute commands in a specific namespace context.

Example: Creating a Network Namespace

```bash
# Create a network namespace named "example_ns"
sudo ip netns add example_ns
```

### 3. ip link command

The ip link command is used for managing network interfaces. When working with network namespaces, it allows you to create virtual interfaces that are associated with a specific namespace.

```bash
# Create a virtual Ethernet interface named "veth0" in the "example_ns" namespace
sudo ip link add veth0 type veth peer name veth1
sudo ip link set veth1 netns example_ns
```

### 4. Executing Commands in a Namespace

The ip netns exec command is used to execute commands in a specific namespace. This is useful for configuring network settings or running applications within the isolated environment.

```bash
# Run a command (e.g., a shell) in the "example_ns" namespace
sudo ip netns exec example_ns bash
```

### 5. Routing and Firewall Rules

Each network namespace has its own routing table and firewall rules. You can use standard Linux networking tools (ip route, iptables, etc.) to configure these settings within a specific namespace.

```bash
# Add a route to the "example_ns" namespace
sudo ip -n example_ns ip route add default via veth1

# Add a firewall rule to the "example_ns" namespace
sudo ip netns exec iptables -A INPUT -i veth1 -p tcp --dport 80 -j ACCEPT
```
