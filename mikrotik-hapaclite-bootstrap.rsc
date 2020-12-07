/interface bridge
add comment=defconf name=bridge
/interface ethernet
set [ find default-name=ether1 ] comment=WAN
/interface list
add comment=defconf name=WAN
add comment=defconf name=LAN
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
add authentication-types=wpa-psk,wpa2-psk eap-methods="" mode=dynamic-keys \
    name=new-post supplicant-identity="" wpa-pre-shared-key=... \
    wpa2-pre-shared-key=...
/interface wireless
set [ find default-name=wlan1 ] antenna-gain=0 band=2ghz-b/g/n channel-width=\
    20/40mhz-XX comment="2.4 GHz" country=moldova disabled=no distance=\
    indoors frequency=auto installation=indoor mode=ap-bridge \
    security-profile=new-post ssid="New Post" station-roaming=enabled \
    wireless-protocol=802.11 wps-mode=push-button-virtual-only
set [ find default-name=wlan2 ] antenna-gain=0 band=5ghz-a/n/ac \
    channel-width=20/40/80mhz-XXXX comment="5 GHz" country=moldova disabled=\
    no distance=indoors frequency=auto installation=indoor mode=ap-bridge \
    security-profile=new-post ssid="New Post 5 GHz" station-roaming=enabled \
    wireless-protocol=802.11 wps-mode=push-button-virtual-only
/interface wireless manual-tx-power-table
set wlan1 comment="2.4 GHz"
set wlan2 comment="5 GHz"
/interface wireless nstreme
set wlan1 comment="2.4 GHz"
set wlan2 comment="5 GHz"
/ip hotspot profile
set [ find default=yes ] html-directory=flash/hotspot
/ip pool
add name=default-dhcp ranges=192.168.105.101-192.168.105.199
/ip dhcp-server
add address-pool=default-dhcp disabled=no interface=bridge name=defconf
/user group
set full policy="local,telnet,ssh,ftp,reboot,read,write,policy,test,winbox,pas\
    sword,web,sniff,sensitive,api,romon,dude,tikapp"
/interface bridge port
add bridge=bridge comment=defconf interface=ether2
add bridge=bridge comment=defconf interface=ether3
add bridge=bridge comment=defconf interface=ether4
add bridge=bridge comment=defconf interface=ether5
add bridge=bridge comment=defconf interface=wlan1
add bridge=bridge comment=defconf interface=wlan2
/ip neighbor discovery-settings
set discover-interface-list=LAN
/interface list member
add comment=defconf interface=bridge list=LAN
add comment=defconf interface=ether1 list=WAN
/ip address
add address=192.168.105.1/24 comment=defconf interface=bridge network=\
    192.168.105.0
add address=... interface=ether1 network=...
/ip dhcp-client
add comment=defconf interface=ether1
/ip dhcp-server network
add address=192.168.105.0/24 comment=defconf gateway=192.168.105.1
/ip dns
set servers=8.8.8.8,8.8.4.4
/ip dns static
add address=192.168.105.1 name=router.lan
/ip firewall filter
add action=accept chain=input comment=\
    "defconf: accept established,related,untracked" connection-state=\
    established,related,untracked
add action=accept chain=input comment=WINBOX dst-port=8291 protocol=tcp
add action=drop chain=input comment="defconf: drop invalid" connection-state=\
    invalid
add action=accept chain=input comment="defconf: accept ICMP" protocol=icmp
add action=drop chain=input comment="defconf: drop all not coming from LAN" \
    in-interface-list=!LAN
add action=accept chain=forward comment="defconf: accept in ipsec policy" \
    ipsec-policy=in,ipsec
add action=accept chain=forward comment="defconf: accept out ipsec policy" \
    ipsec-policy=out,ipsec
add action=fasttrack-connection chain=forward comment="defconf: fasttrack" \
    connection-state=established,related
add action=accept chain=forward comment=\
    "defconf: accept established,related, untracked" connection-state=\
    established,related,untracked
add action=drop chain=forward comment="defconf: drop invalid" \
    connection-state=invalid
add action=drop chain=forward comment=\
    "defconf: drop all from WAN not DSTNATed" connection-nat-state=!dstnat \
    connection-state=new in-interface-list=WAN
/ip firewall nat
add action=masquerade chain=srcnat comment="defconf: masquerade" \
    ipsec-policy=out,none out-interface-list=WAN
add action=dst-nat chain=dstnat dst-port=554 in-interface-list=WAN protocol=\
    tcp to-addresses=192.168.105.201 to-ports=554
add action=dst-nat chain=dstnat dst-port=555 in-interface-list=WAN protocol=\
    tcp to-addresses=192.168.105.202 to-ports=554
add action=dst-nat chain=dstnat dst-port=556 in-interface-list=WAN protocol=\
    tcp to-addresses=192.168.105.203 to-ports=554
/ip route
add distance=1 gateway=...
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set ssh disabled=yes
set api disabled=yes
set api-ssl disabled=yes
/system clock
set time-zone-name=Europe/Chisinau
/system identity
set name="Chisinau Mircea cel Batrin ..."
/tool mac-server
set allowed-interface-list=LAN
/tool mac-server mac-winbox
set allowed-interface-list=LAN
