# Autorite de certification d'entreprise LABO-AIS-CA.

Install-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools

Install-AdcsCertificationAuthority -CAType EnterpriseRootCA -CACommonName "LABO-AIS-CA" `
  -KeyLength 4096 -HashAlgorithmName SHA256 -ValidityPeriod Years -ValidityPeriodUnits 10 -Force

# Inscription automatique du certificat de controleur de domaine (active LDAPS)
certutil -pulse
gpupdate /force
