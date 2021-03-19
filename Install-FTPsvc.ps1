#Requires -RunAsAdministrator

##
# Install the FTP feature:
##
$iisweb = Get-WindowsOptionalFeature -Online -FeatureName IIS-WebServer
Enable-WindowsOptionalFeature -Online -FeatureName IIS-FTPsvc,IIS-FTPserver,IIS-WebServerRole,
	IIS-ManagementConsole,IIS-ManagementScriptingTools,IIS-WebServerManagementTools
if($iisweb.state -eq $false) { Disable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer }

##
# Load the command line tools to manage FTP:
##
Import-Module WebAdministration

##
# Create the *default* FTP site.
# //Don't edit this; user folders are added elsewhere//
##

$FTPSiteName = 'Default FTP Site'
$FTPRootDir = '%SystemDrive%\inetpub\ftproot'
$FTPPort = 21
New-WebFtpSite -Name $FTPSiteName -Port $FTPPort -PhysicalPath $FTPRootDir

## 
# Configure IIS to allow FTP login using Basic Authentication (username & password)
##
$FTPSitePath = "IIS:\Sites\$FTPSiteName"
$BasicAuth = 'ftpServer.security.authentication.basicAuthentication.enabled'
Set-ItemProperty -Path $FTPSitePath -Name $BasicAuth -Value $True

##
# Configure IIS to *allow* (but not /require/) SSL when connecting by FTP.
##
$SSLPolicy = @(
    'ftpServer.security.ssl.controlChannelPolicy',
    'ftpServer.security.ssl.dataChannelPolicy'
)
Set-ItemProperty -Path $FTPSitePath -Name $SSLPolicy[0] -Value $false
Set-ItemProperty -Path $FTPSitePath -Name $SSLPolicy[1] -Value $false

## 
# Configure *who* is allowed to login to FTP: all users.
##
$Param = @{
    Filter   = "/system.ftpServer/security/authorization"
    Value    = @{
        accessType  = "Allow"
        roles       = "Users"
        permissions = 3
    }
    PSPath   = "IIS:\\"
    Location = $FTPSiteName
}
Add-WebConfiguration @param

##
# Finally, add the appropriat exception to the Windows Firewall.
##
Enable-NetFirewallRule -Group "@%SystemRoot%\system32\firewallapi.dll,-38525"

##
# That's it! All users will now be able to connect. But there's nothing there yet!
##
