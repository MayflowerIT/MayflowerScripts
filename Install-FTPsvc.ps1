
<#PSScriptInfo

.VERSION 0.9

.GUID a417e704-df6c-41ba-800a-d3826bf971ad

.AUTHOR John@MayflowerIT.com

.COMPANYNAME Mayflower IS&T

.COPYRIGHT (c) gaelicWizard.LLC. All Rights Reserved.

.TAGS 

.LICENSEURI 

.PROJECTURI https://github.com/MayflowerIT/MayflowerScripts

.ICONURI 

.EXTERNALMODULEDEPENDENCIES WebAdministration

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


#>

<# 
.DESCRIPTION 
 Install and configure the Windows FTP Service 

#> 
Param($FTPUserName='scan', $FTPPassword='OMGftp123$')

#Requires -RunAsAdministrator

$FTPsvc = Get-WindowsOptionalFeature -Online -FeatureName IIS-FTPsvc

if ($FTPsvc.State -ne "Enabled")
{
    $FTPOptionalFeature = Enable-WindowsOptionalFeature -Online -FeatureName IIS-FTPSvc,IIS-ManagementConsole,IIS-ManagementService,IIS-ManagementScriptingTools,IIS-FTPExtensibility -All -NoRestart
    if ($FTPOptionalFeature.RestartNeeded -eq $true)
    {
        Restart-Computer -Force
    }
}

set-NetFirewallRule -DisplayGroup "FTP Server" -Enabled True -Profile Private,Domain -ErrorAction Stop
#Enable-NetFirewallRule -Group "@%SystemRoot%\system32\firewallapi.dll,-38525"
Disable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer -Verbose -ErrorAction Continue -NoRestart

Remove-Item "C:\TYPSoft FTP Server" -Force -Recurse -ErrorAction SilentlyContinue

Import-Module WebAdministration -ErrorAction Stop


ICACLS "$ENV:SystemRoot\System32\inetsrv\config" /grant "Network Service:(CI)(OI)(R)"


#Creating new FTP site
$DefaultFTPSite = @{
    Name = "Default FTP Site"
    PhysicalPath = "C:\inetpub\ftproot"
    Port = 21
}
$SiteName = $DefaultFTPSite.Name #"Default FTP Site"

$FTPscan = "C:\Incoming Scan"

New-WebFtpSite @DefaultFTPSite #-Name $SiteName -PhysicalPath $RootFolderpath -Port $PortNumber #-Verbose -Force


# Changing SSL policy of the FTP site

'ftpServer.security.ssl.controlChannelPolicy', 'ftpServer.security.ssl.dataChannelPolicy' |
ForEach-Object {
          Set-ItemProperty -Path "IIS:\Sites\$SiteName" -Name $_ -Value $false
}

New-Item -ItemType Directory -Path $FTPscan -ErrorAction SilentlyContinue
ICACLS "$ENV:SystemDrive\inetpub\ftproot" /grant "Network Service:(CI)(OI)(M)"

New-WebVirtualDirectory -Site $SiteName -Name scan -PhysicalPath $FTPscan # doesn't work...


[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Web.Management") 
[Microsoft.Web.Management.Server.ManagementAuthentication]::CreateUser($FTPUserName, $FTPPassword)
[Microsoft.Web.Management.Server.ManagementAuthorization]::Grant($FTPUserName, $SiteName, $FALSE)
#Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -location "$siteName" -filter "system.ftpServer/security/authorization" -name "." -value @{accessType='Allow';users="$FTPUserName";permissions="Read,Write"}


C:\Windows\System32\inetsrv\appcmd.exe set config -section:system.applicationHost/sites /+"siteDefaults.ftpServer.security.authentication.customAuthentication.providers.[name='IisManagerAuth',enabled='True']" /commit:apphost
$FTPmgr = @{
             Path    = "IIS:\Sites\$SiteName"
             Name    = 'ftpserver.security.authentication.customAuthentication.providers.add.name'
             Value   = 'IisManagerAuth'
             Verbose = $True
}
Set-ItemProperty @FTPmgr

# Enabling basic authentication on the FTP site
$FTPbasic = @{
             Path    = "IIS:\Sites\$SiteName"
             Name    = 'ftpserver.security.authentication.basicauthentication.enabled'
             Value   = $true
             Verbose = $True
}

Set-ItemProperty @FTPbasic

# Adding authorization rule to allow FTP users
# in the FTP group to access the FTP site

$FTPreadAll = @{
             PSPath = 'IIS:\'
             Location = $SiteName
             Filter = '/system.ftpserver/security/authorization'
             Value = @{ accesstype = 'Allow'; users = "*"; permissions = 1 }
}

Add-WebConfiguration @FTPreadAll #-ErrorAction SilentlyContinue

$FTPrwScan = @{
             PSPath = 'IIS:\'
             Location = "$SiteName/scan"
             Filter = '/system.ftpserver/security/authorization'
             Value = @{ accesstype = 'Allow'; users = "*"; permissions = 3 }
}

Add-WebConfiguration @FTPrwScan
