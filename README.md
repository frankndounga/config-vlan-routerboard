# vlan configuration on mikrotik routerboard
**Topology**
I have on router connected to the internet ISP it is considered as a distribution router(layer)
Another router connected to the de distribution router via a trunk link.
I will configure 3 vlans (10,20,30) and three hosts which are vpcs each on a specific vlan.
Subnets
- vlan10 : 172.16.10.0/24
- vlan20 : 172.16.20.0/24
- vlan30 : 172.16.30.0/24

![Topology](config_vlan_topology.png)

## configuration with devices whithout switch chipset
This method is use when we configure vlans on a device that doesn't have a switch chipset or even when we want to configure vlans on wireless interfaces. Because wireless interface doesn't belong to the chipset switch group. As i am using CHR in the lab i don't have switch chipset then i will first use this method and after that use my physical RB951 Mikrotik router to configure vlan via the switch chipset it does effectively has the switch chipset.

1- i will configure the distribution router as the gateway of the topology 
configure the ether1 interface as dhcp which is already enable by default to receive the ip address from the ISP
![ether1 ip address](check_ipdhcp_client)
ping to test the connection to internet
enable nat masquerade for all ip sources 
` ip firewall nat add chain=srcnat action=masquerade out-interface=ether1`

2- i create new vlans interfaces under ether2 on the distribution router for each vlan
![create interface vlan](create_vlan_interface.png)
![vlans](after_create_vlans_interfaces.png)
As when i want to route paquet with a layer 3 cisco switch, to do a router on a stick the address i give to these vlan interfaces is considered to be the gateway address for the vlan subnet. In my case, i will take the last usable address of each subnets. then
172.16.10.254 for vlan10
172.16.20.254 for vlan20
172.16.30.254 for vlan30
![ip vlan assignment](ip_vlan_assignment)
i create dhcp servers for each vlan subnet
ip dhcp-server setup 

3- As i am connected to the distribution router i will access the access-router via ip neighbor and mac telnet to edit romon mode via the cli and connect to this router in romon.
![connect via neighbor](connect_to_access_router.png)
I create a bridge interface SWITCH-BRIDGE.
I add ethe1 and all the other interfaces that will be in different vlans on this bridge. on these interfaces i configure the vlanID.
I configure three vlan bridge for vlan10, 20, 30
![vlan filtering interface](vlan_filtering_on_interface.png)
![vlan filtering bridge](vlan_filtering_bridge.png)
![vlans config](vlan_bridge_configuration.png)
And i enable vlan filtering on the bridge (This step is important to be made last or i lost the connectivity, i will investigate why)

4- I enable dhcp on VPCS to make sur each VPC receive an ip address in the range of its vlan subnet
![vlan10 client](vlan10-client-ip-address)
![vlan20 client](vlan20-client-ip-address)
![vlan30 client](vlan30-client-ip-address)

6- Test connectivity to internet
ping the google dns server from vlan10-client
![ping google dns server](ping_google_from_vpcs.png)

Bonus: Wireshark
via wireshark we can see the ethernet frame is untagged coming out of the pc to the access router
![wireshark captute](shark_capture_ping_vlan20client.pns)

and the frame is tagged coming out fro the access router to the distribution router via the trunk link with IEEE 80.2.1q tag.
![wireshark capture dot1q](shark_capture_dot1q.png)


This means if i deploy services i can easily differentiate  between them via vlans because segments are different by having just one physical cable to the access router very useful to avoid too many cables in an environment. I can for example configure different policies related to specific vlan depending on my needs on the router. When studying for the CCNA i did not often really see the need of vlans other than reducing the broadcast domains. But as i gradually configure equipments, its use becomes really clear.
