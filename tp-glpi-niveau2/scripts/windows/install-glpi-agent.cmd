@echo off
rem Script de demarrage GPO : installe GLPI Agent s'il est absent.
rem Emplacement : \\labo-ais.lan\NETLOGON\glpi-agent\

reg query "HKLM\SOFTWARE\GLPI-Agent" >nul 2>&1 && exit /b 0

set SRC=\\labo-ais.lan\NETLOGON\glpi-agent
set MSI=GLPI-Agent-1.20-x64.msi
set CA=%ProgramData%\LABO\LABO-AIS-CA.pem

if not exist "%ProgramData%\LABO" mkdir "%ProgramData%\LABO"
copy /y "%SRC%\LABO-AIS-CA.pem" "%CA%" >nul

msiexec /i "%SRC%\%MSI%" /quiet SERVER="https://glpi.labo-ais.lan/" ^
  CA_CERT_FILE="%CA%" TAG=LABO RUNNOW=1 ADD_FIREWALL_EXCEPTION=1 ^
  /l*v "%WINDIR%\Temp\glpi-agent-install.log"
