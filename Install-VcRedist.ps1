#Requires -RunAsAdministrator

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Register-PSRepository -Default -InstallationPolicy Trusted -ErrorAction SilentlyContinue
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Install-Module -Name PowerShellGet -Confirm:$false -AllowClobber
Update-Module -Name PowerShellGet -Confirm:$false -ErrorAction SilentlyContinue
#Install-Module -Name PackageManagement -Force -AllowClobber #unneccessary

Install-Module VcRedist -Scope AllUsers -confirm:$false
Update-Module VcRedist -Confirm:$false
Import-Module VcRedist
$vcTemp = "$ENV:TEMP\VcRedists"
md $vcTemp -Force
$VcList = Get-VcList | Get-VcRedist -Path $vcTemp
$VcList | Install-VcRedist -Path $vcTemp -Silent
