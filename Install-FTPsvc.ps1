#Requires -RunAsAdministrator

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
Param($FTPUserName='scan', $FTPPassword='OMGftp123$', $FTPSiteName='Default FTP Site', $FTPSiteRoot='C:\inetpub\ftproot', $FTPPort='21', $Online=$true, $FTPScansFolder=(JoinPath $ENV:SystemDrive "Incoming Scan"), $FTPScansFolderName='Incoming Scans' )

$IISdrive = 'IIS:\'
$inetpub = Join-Path $ENV:SystemDrive "inetpub"

#Creating new FTP site
$DefaultFTPSite = @{
    Name = $FTPSiteName
    PhysicalPath = $FTPSiteRoot
    Port = $FTPPort
}
$FTPSite = @{
    Path = Join-Path (Join-Path $IISdrive "Sites") $FTPSiteName
}
$FTPwcfg = @{
    PSPath = $IISdrive
    Location = $FTPSiteName
}
$FTPScan = @{
    Name = 'scan'
    PhysicalPath = $FTPScansFolder
}

function Install-IISFTPService
{
    $IISweb = Get-WindowsOptionalFeature -Online -FeatureName IIS-WebServer
    $IISmgmt = Get-WindowsOptionalFeature -Online -FeatureName IIS-ManagementService
    $FTPsvc = Get-WindowsOptionalFeature -Online -FeatureName IIS-FTPsvc
    $FTPext = Get-WindowsOptionalFeature -Online -FeatureName IIS-FTPExtensibility

    if (($FTPsvc.State -ne "Enabled") -or ($IISmgmt -ne "Enabled") -or ($FTPext -ne "Enabled"))
    {
        $FTPOptionalFeature = Enable-WindowsOptionalFeature -Online -FeatureName IIS-FTPSvc,IIS-ManagementConsole,IIS-ManagementService,IIS-ManagementScriptingTools,IIS-FTPExtensibility -All -Restart

        if ($IISweb.State -ne "Enabled")
        {
            Disable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer -ErrorAction Continue -NoRestart
        }
    }

    set-NetFirewallRule -DisplayGroup "FTP Server" -Enabled True -Profile Private,Domain -ErrorAction Stop
    #Enable-NetFirewallRule -Group "@%SystemRoot%\system32\firewallapi.dll,-38525"

    ICACLS "$ENV:SystemRoot\System32\inetsrv\config" /grant "Network Service:(CI)(OI)(R)"
}


Configure-IISFTPService
{
    Import-Module WebAdministration -ErrorAction Stop
    New-WebFtpSite @DefaultFTPSite #-ErrorAction SilentlyContinue

    ICACLS $DefaultFTPSite.PhysicalPath /grant "Network Service:(CI)(OI)(M)"

    'ftpServer.security.ssl.controlChannelPolicy', 'ftpServer.security.ssl.dataChannelPolicy' |
    ForEach-Object { # Allow, but do not require TLS/SSL
        Set-ItemProperty @FTPSite -Name $_ -Value $false
    }
    'ftpserver.security.authentication.basicauthentication.enabled' |
    ForEach-Object { # Enable cleartext authentication
        Set-ItemProperty @FTPSite -Name $_ -Value $true
    }

    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Web.Management") 
    [Microsoft.Web.Management.Server.ManagementAuthentication]::CreateUser($FTPUserName, $FTPPassword)
    [Microsoft.Web.Management.Server.ManagementAuthorization]::Grant($FTPUserName, $FTPSiteName, $FALSE)
#Add-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -location "$FTPSiteName" -filter "system.ftpServer/security/authorization" -name "." -value @{accessType='Allow';users="$FTPUserName";permissions="Read,Write"}
    appcmd.exe set config -section:system.applicationHost/sites /+"siteDefaults.ftpServer.security.authentication.customAuthentication.providers.[name='FtpCustomAuthenticationModule',enabled='True']" /commit:apphost
    $FTPmgr = @{
        Name    = 'ftpserver.security.authentication.customAuthentication.providers.add.name'
        Value   = 'IisManagerAuth'
        Verbose = $True
    }
    #Set-ItemProperty @FTPSite @FTPmgr

    $FTPreadAll = @{
        Filter = '/system.ftpserver/security/authorization'
        Value = @{ accesstype = 'Allow'; users = "*"; permissions = 1 }
    }
    Add-WebConfiguration @FTPwcfg @FTPreadAll #-ErrorAction SilentlyContinue
}
