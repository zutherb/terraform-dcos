* Original method of deployment does not work with multi master - DC/OS services are failing on each master node.
- Exhibitor/ZooKeeper is deployed successfully in HA manner, DC/OS services are unable to start
- Building multi master with dcos-config and dcos-metadata packages from working configuration results in 3 separate masters
- Downgrading to 1.8.4 does not solve the problem
* All masters are created in the same availability zone
* OpenVPN server hostname is not being changed to the load balancer hostname
- Because of that there it is required to manually change the hostname in order for VPN to work properly
* OpenVPN server was not configured at all
- CLI commands were executed before OpenVPN service has initialized
- Deployment script has been rewritten and OpenVPN is now configured properly
