
<#PSScriptInfo

.VERSION 1.0

.GUID d78d50d5-52bf-4908-a44a-0f8bc989c921

.AUTHOR John D Pell

.COMPANYNAME Mayflower IS&T

.COPYRIGHT (c) gaelicWizard.LLC. All Rights Reserved.

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Configures visibility of network adapters 

#> 

#Requires -RunAsAdministrator
Param(
    [Switch]$Online = $false
)
#https://docs.microsoft.com/en-us/windows-hardware/drivers/network/keywords-not-displayed-in-the-user-interface
#https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/hiding-network-adapter



Function Get-NetAdapterVisibility
$GetScript = {
    Param(
        $Description = $using:svcname
    )

    $NetworkAdapterClass = [guid]"4D36E972-E325-11CE-BFC1-08002BE10318"
    $RegisteredDriverClasses = "HKLM:\SYSTEM\CurrentControlSet\Control\Class"
    $NetworkAdapterInstances = Join-Path $RegisteredDriverClasses "{$NetworkAdapterClass}"
    $NAK = Join-Path $NetworkAdapterInstances "*"

    $NA = Get-ItemProperty -Path $NAK -ErrorAction SilentlyContinue | 
    Where-Object DriverDesc -like $Description -ErrorAction SilentlyContinue

    $NA | Select-Object DriverDesc, '*NdisDeviceType', PSPath
}
$State = [scriptblock]::Create($GetScript).Invoke()

Function Set-NetAdapterVisibility
{
    Param(
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        $PSPath,
        [switch]$ignoreNLA
    )

    Process
    {
        if ($ignoreNLA) {
            New-ItemProperty $PSPath -name '*NdisDeviceType' -propertytype dword -value 1 | Out-Null
        } else {
            Remove-ItemProperty $PSPath -name '*NdisDeviceType' 
}   }   }

if($true -eq $Online)
{
    Get-NetAdapterVisibility -Description "*Hamachi*" | Set-NetAdapterVisibility -ignoreNLA
}


