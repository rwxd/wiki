# NVIDIA AIR
## SSH Configuration

```cfg
Host nvidia-air  
       HostName worker04.air.nvidia.com  
       Port 24580  
       User cumulus  
       StrictHostKeyChecking no  
Host leaf0* spine0* border0* server0*  
       ProxyJump nvidia-air  
       User cumulus  
       StrictHostKeyChecking no
```