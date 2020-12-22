#Requires -RunAsAdministrator
#Requires -Version 5.0
#Requires -Modules PackageManagement

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Scope AllUsers 
#-Force
Register-PSRepository -Default -InstallationPolicy Trusted -ErrorAction SilentlyContinue # Only needed if something gets corrupted...
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -ErrorAction STOP

#Install-Module -Name PackageManagement -AllowClobber -Confirm:$false # This should be auto-installed by the next line anyway
Install-Module -Name PowerShellGet -AllowClobber -Scope AllUsers -MinimumVersion 2.0 -WarningAction STOP
if ($False -eq $?)
{
	Install-Module -Name PowerShellGet -AllowClobber -Scope AllUsers -MinimumVersion 2.0 -WarningAction STOP -FORCE -verbose
}
