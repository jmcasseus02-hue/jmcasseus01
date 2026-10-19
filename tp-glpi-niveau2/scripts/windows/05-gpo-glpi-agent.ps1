# Cree la GPO de deploiement et la lie a l'OU des ordinateurs.
# Le script de demarrage est ensuite ajoute dans gpmc.msc (Configuration ordinateur >
# Strategies > Parametres Windows > Scripts > Demarrage) :
#   \\labo-ais.lan\NETLOGON\glpi-agent\install-glpi-agent.cmd

Import-Module GroupPolicy
New-GPO -Name "GPO-Deploiement-GLPI-Agent" -Comment "Installation de GLPI Agent au demarrage"
New-GPLink -Name "GPO-Deploiement-GLPI-Agent" -Target "OU=Ordinateurs,OU=LABO,DC=labo-ais,DC=lan"

# Toujours attendre le reseau au demarrage, sinon NETLOGON peut etre injoignable
Set-GPRegistryValue -Name "GPO-Deploiement-GLPI-Agent" `
  -Key "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" `
  -ValueName SyncForegroundPolicy -Type DWord -Value 1
