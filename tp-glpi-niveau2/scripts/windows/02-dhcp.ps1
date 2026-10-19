# Role DHCP sur DC01 : autorisation dans l'AD, etendue et options.

Install-WindowsFeature DHCP -IncludeManagementTools
netsh dhcp add securitygroups
Restart-Service DHCPServer
Add-DhcpServerInDC -DnsName "dc01.labo-ais.lan" -IPAddress 10.10.10.10

Add-DhcpServerv4Scope -Name "LAN-LABO" -StartRange 10.10.10.100 -EndRange 10.10.10.150 `
  -SubnetMask 255.255.255.0 -LeaseDuration 8.00:00:00 -State Active

Set-DhcpServerv4OptionValue -ScopeId 10.10.10.0 -Router 10.10.10.254 `
  -DnsServer 10.10.10.10 -DnsDomain "labo-ais.lan"

Set-DhcpServerv4DnsSetting -ScopeId 10.10.10.0 -DynamicUpdates Always -DeleteDnsRRonLeaseExpiry $true
