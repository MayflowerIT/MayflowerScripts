
<#PSScriptInfo

.VERSION 1.0

.GUID 1c3815d8-144f-4681-8323-b32bef6965c5

.AUTHOR John D Pell

.COMPANYNAME Mayflower IS&T

.COPYRIGHT Original (c) Microsoft Corporation. Improvements (c) gaelicWizard.LLC.

.TAGS

.LICENSEURI

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Original imported from Azure AD Connect Seamless Single Sign-On manual script. 


.PRIVATEDATA

#>

<# 
.SYNOPSIS
 Configures the service connection point for Hybrid Azure AD join in the current forest.

.DESCRIPTION 
 The ConfigureSCP.ps1 script inspects your on-premises Active Directory Domain Services forest and updates or creates the service connection point for Hybrid Azure AD join and Single Sign-On.

.PARAMETER AADDomain
 Specifies the original "default" domain used to configure Azure AD, usually <contoso>.onmicrosoft.com.

.PARAMETER AADTenant
 Specifies the GUID for the Azure AD tenant.

.PARAMETER ADDSForest
 Specifies the distinguished name for your on-premises Active Directory Domain Services root domain.
#> 

Param(
     [Parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]
     [String]$AADDomain, 
     [Parameter(Mandatory=$true)]
     [ValidateNotNullOrEmpty()]
     [Guid]$AADTenant,
     [String]$ADDSForest
)

function funHelp()
{
     $helpTxt = @"

     NAME:        ConfigureSCP.ps1
     PURPOSE:     Configures the service connection point for Hybrid Azure AD join in the current forest
     REQUIREMENT: Must be run by an Enterprise Admin of the current forest

     PARAMETERS: 

        -Domain <NAME>  Specifies the Azure AD domain to use for device authentication
               If you are using federation to authenticate with Azure AD, enter a federated domain name.
               If you are not using federation, enter your primary *.onmicrosoft.com domain name.

        -Help           Prints the help file

     EXAMPLES:

     1. ConfigureSCP.ps1 -Domain contoso.com

     2. ConfigureSCP.ps1 -Domain contoso.onmicrosoft.com

"@
     $helpTxt
     exit 1
}

Function ConvertTo-DistinguishedName()
{ # http://jeffwouters.nl/index.php/2012/05/convert-a-domain-name-to-a-usable-distinguished-name-format/
<#
.Synopsis
Function to convert a domain name into a distinguished name format.

  .Description
Function to convert a domain name into a distinguished name format.
No default is used.

  .Example
Convert-ToDistinguishedName -DomainName “jeffwouters.lan”

  .Example
Convert-ToDistinguishedName -Name “jeffwouters.lan”

  .Notes
Author: Jeff Wouters | Methos IT
#>
param ( [Parameter(Position=0, Mandatory=$True)][ValidateNotNullOrEmpty()][Alias(‘Name’)][String]$DomainName )
$DomainSplit = $DomainName.split(“.”)
if ($DomainSplit[2] -ne $null) {
$DomainName = “DC=$($DomainSplit[0]),DC=$($DomainSplit[1]),DC=$($DomainSplit[2])”
$DomainName
} else {
$DomainName = “DC=$($DomainSplit[0]),DC=$($DomainSplit[1])”
$DomainName
}
}



Write-Verbose "Configuring the SCP for Hybrid Azure AD join in your Active Directory forest."

## Set variables
$azureADId = "azureADId:" + $AADTenant
$azureADName = "azureADName:" + $AADDomain
$keywords = "keywords"
$ldap = "LDAP://"
if(-not($ADDSForest))
{
     $rootDSE = New-Object System.DirectoryServices.DirectoryEntry($ldap + "RootDSE")
}
else
{
     $rootDSE = New-Object System.DirectoryServices.DirectoryEntry($ldap + (ConvertTo-DistinguishedName -name $ADDSForest))
     
}
$configCN = $rootDSE.Properties["configurationNamingContext"][0].ToString()
$servicesCN = "CN=Services," + $configCN
$drcCN = "CN=Device Registration Configuration," + $servicesCN
$scpCN = "CN=62a0ff2e-97b9-4513-943f-0d221bd30080," + $drcCN

## Get/Create: CN=Device Registration Configuration,CN=Services
if ([System.DirectoryServices.DirectoryEntry]::Exists($ldap + $drcCN))
{
     $deDRC = New-Object System.DirectoryServices.DirectoryEntry($ldap + $drcCN)
}
else
{
     $de = New-Object System.DirectoryServices.DirectoryEntry($ldap + $servicesCN)
     $deDRC = $de.Children.Add("CN=Device Registration Configuration", "container")
     $deDRC.CommitChanges()
}

## Edit/Create: CN=62a0ff2e-97b9-4513-943f-0d221bd30080,CN=Device Registration Configuration,CN=Services
if ([System.DirectoryServices.DirectoryEntry]::Exists($ldap + $scpCN))
{
     $deSCP = New-Object System.DirectoryServices.DirectoryEntry($ldap + $scpCN)
     foreach ($value in $deSCP.Properties[$keywords].Value)
     {
          $deSCP.Properties[$keywords].Remove($value)
     }
     $deSCP.Properties[$keywords].Add($azureADName)
     $deSCP.Properties[$keywords].Add($azureADId)
     $deScp.CommitChanges()
}
else
{
     $deSCP = $deDRC.Children.Add("CN=62a0ff2e-97b9-4513-943f-0d221bd30080", "serviceConnectionPoint")
     $deSCP.Properties[$keywords].Add($azureADName)
     $deSCP.Properties[$keywords].Add($azureADId)
     $deScp.CommitChanges()
}

if ($Error)
{
     Write-Error "Configuration could not be completed."
     Write-Error $Error
}
else
{
     Write-Verbose "Configuration complete!"
}
