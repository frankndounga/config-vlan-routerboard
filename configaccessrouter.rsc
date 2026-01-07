# jan/07/2026 15:46:31 by RouterOS 6.49.18
# software id = 
#
#
#
/interface bridge
add name=SWITCH-BRIDGE vlan-filtering=yes
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
set [ find default-name=ether4 ] disable-running-check=no
set [ find default-name=ether5 ] disable-running-check=no
set [ find default-name=ether6 ] disable-running-check=no
set [ find default-name=ether7 ] disable-running-check=no
set [ find default-name=ether8 ] disable-running-check=no
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/interface bridge port
add bridge=SWITCH-BRIDGE interface=ether2 pvid=10
add bridge=SWITCH-BRIDGE interface=ether3 pvid=20
add bridge=SWITCH-BRIDGE interface=ether4 pvid=30
add bridge=SWITCH-BRIDGE interface=ether1
/interface bridge vlan
add bridge=SWITCH-BRIDGE tagged=ether1 untagged=ether2 vlan-ids=10
add bridge=SWITCH-BRIDGE tagged=ether1 untagged=ether3 vlan-ids=20
add bridge=SWITCH-BRIDGE tagged=ether1 untagged=ether4 vlan-ids=30
/ip dhcp-client
add interface=ether1
/system identity
set name=access-router
/tool romon
set enabled=yes secrets=1234
