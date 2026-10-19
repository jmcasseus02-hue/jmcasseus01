# Prepare le partage NETLOGON pour le deploiement de GLPI Agent :
# telecharge le MSI 64 bits et exporte la racine LABO-AIS-CA au format PEM.

$dir = "C:\Windows\SYSVOL\sysvol\labo-ais.lan\scripts\glpi-agent"
New-Item -ItemType Directory -Path $dir -Force | Out-Null

$rel   = Invoke-RestMethod https://api.github.com/repos/glpi-project/glpi-agent/releases/latest
$asset = $rel.assets | Where-Object name -match '^GLPI-Agent-[\d.]+-x64\.msi$' | Select-Object -First 1
Invoke-WebRequest $asset.browser_download_url -OutFile "$dir\$($asset.name)" -UseBasicParsing

$cert = Get-ChildItem Cert:\LocalMachine\Root | Where-Object Subject -like "*LABO-AIS-CA*" | Select-Object -First 1
Export-Certificate -Cert $cert -FilePath "$env:TEMP\ca.cer" -Type CERT | Out-Null
certutil -f -encode "$env:TEMP\ca.cer" "$dir\LABO-AIS-CA.pem"

Get-ChildItem $dir | Select-Object Name, Length
