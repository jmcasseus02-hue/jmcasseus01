# Structure de l'annuaire : OU, groupes GLPI, comptes de test et compte de service.
# A executer sur DC01 avec un compte administrateur du domaine.

$base = "DC=labo-ais,DC=lan"

New-ADOrganizationalUnit -Name LABO -Path $base
foreach ($ou in 'Utilisateurs','Groupes','Ordinateurs','Serveurs','Services') {
  New-ADOrganizationalUnit -Name $ou -Path "OU=LABO,$base"
}

# Les nouveaux ordinateurs joints au domaine arrivent directement dans OU=Ordinateurs
redircmp "OU=Ordinateurs,OU=LABO,$base"

foreach ($g in 'GG-GLPI-Admins','GG-GLPI-Techniciens','GG-GLPI-Utilisateurs') {
  New-ADGroup -Name $g -GroupScope Global -GroupCategory Security -Path "OU=Groupes,OU=LABO,$base"
}

$pwd = Read-Host -AsSecureString "Mot de passe des comptes de test"
$users = @(
  @{Sam='j.dupont'; Prenom='Jean';  Nom='Dupont'; Groupe='GG-GLPI-Techniciens'},
  @{Sam='m.martin'; Prenom='Marie'; Nom='Martin'; Groupe='GG-GLPI-Utilisateurs'},
  @{Sam='a.admin';  Prenom='Alex';  Nom='Admin';  Groupe='GG-GLPI-Admins'}
)
foreach ($u in $users) {
  New-ADUser -Name "$($u.Prenom) $($u.Nom)" -GivenName $u.Prenom -Surname $u.Nom `
    -SamAccountName $u.Sam -UserPrincipalName "$($u.Sam)@labo-ais.lan" `
    -EmailAddress "$($u.Sam)@labo-ais.lan" -Path "OU=Utilisateurs,OU=LABO,$base" `
    -AccountPassword $pwd -Enabled $true
  Add-ADGroupMember -Identity $u.Groupe -Members $u.Sam
}

# Compte de service en lecture seule pour GLPI
New-ADUser -Name "svc-glpi" -SamAccountName svc-glpi -Path "OU=Services,OU=LABO,$base" `
  -AccountPassword (Read-Host -AsSecureString "Mot de passe svc-glpi") -Enabled $true `
  -PasswordNeverExpires $true -CannotChangePassword $true -Description "Lecture LDAP GLPI"
