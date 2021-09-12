# NSX-T Management Plane
NSX-T Manager is at the core of the management plane and provides a wide system view of everything involved. It is a single API entry point responsible for maintaining things such as user configuration, user queries and operational responsibilities for the three planes (management, control, data).

Saves the desired configuration and statistical information. The configuration is then pushed by NSX-T Manager to the control plane which then converts to an active configuration at the data plane level.

All NSX-T components have a MPA (Management Plane Agent) which connects that components back to the NSX-T Manager.