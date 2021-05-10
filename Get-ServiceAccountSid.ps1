<# 
.SYNOPSIS 
This script calculates the SID of a Virtual Service Account.
.DESCRIPTION 
Virtual service accounts are used by Windows Server 2008 and later to isolate services without the 
complexity of password management and local accounts.  However, the SID for these accounts is not 
stored in the SAM database.  Instead, it is calculated based on the service name.  This script
performs that calculation to arrive at the SID for a service account.  This same calculation
can be preformed by the sc.exe ustility using "sc.exe showsid <service_name>".
.LINK
https://pcsxcetrasupport3.wordpress.com/2013/09/08/how-do-you-get-a-service-sid-from-a-service-name/
.NOTES
    File Name  : 
    Get-ServiceAccountSid.ps1
    Authors    : 
        LandOfTheLostPass (www.reddit.com/u/LandOfTheLostPass)
    Version History:
        2016-10-06 - Inital Script Creation
.EXAMPLE
Get-ServiceAccountSid -ServiceName "MSSQLSERVER"
.PARAMETER ServiceName
The name of the service to calculate the sid for (case insensitive)
#>  
Param (
    [Parameter(position = 0, mandatory = $true)]
    [string]$ServiceName
)
$nameBytes = [System.Text.Encoding]::Unicode.GetBytes($ServiceName.ToUpper())
$hashBytes = ([System.Security.Cryptography.SHA1]::Create()).ComputeHash($nameBytes, 0, $nameBytes.Length)
[Array]::Reverse($hashBytes)
$hashString = $hashBytes | %{ $_.ToString("X2") }
$blocks = @()
for($i = 0; $i -lt 5; $i++) {
    $blocks += [Convert]::ToInt64("0x$([String]::Join([String]::Empty, $hashString, ($i * 4), 4))", 16)
}
[Array]::Reverse($blocks)
Write-Output "S-1-5-80-$([String]::Join("-", $blocks))" 


#####


$acl = get-acl "ad:CN={31B2F340-016D-11D2-945F-00C04FB984F9},CN=Policies,CN=System,DC=SerraMedicalClinic,DC=net"
$acl.access #to get access right of the OU
$name = 'NT Service\MyflwrSync'
$AdObj = New-Object System.Security.Principal.NTAccount('NT Service','MyflwrSync')
$strSID = $AdObj.Translate([System.Security.Principal.SecurityIdentifier])
$sid = $strSID.Value
$sid = "S-1-5-80-$([String]::Join("-", $blocks))" 
# Create a new access control entry to allow access to the OU
$identity = [System.Security.Principal.IdentityReference] $strSID
$adRights = [System.DirectoryServices.ActiveDirectoryRights] "GenericAll"
$type = [System.Security.AccessControl.AccessControlType] "Allow"
$inheritanceType = [System.DirectoryServices.ActiveDirectorySecurityInheritance] "All"
$ACE = New-Object System.DirectoryServices.ActiveDirectoryAccessRule $identity,$adRights,$type,$inheritanceType
# Add the ACE to the ACL, then set the ACL to save the changes
$acl.AddAccessRule($ace)
Set-acl -aclobject $acl "ad:CN={31B2F340-016D-11D2-945F-00C04FB984F9},CN=Policies,CN=System,DC=SerraMedicalClinic,DC=net"
