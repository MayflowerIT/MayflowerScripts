
<#PSScriptInfo

.VERSION 0.1

.GUID 7e8346b0-d383-4b4a-b54b-5c23b13e4dbd

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
 Well known security identifier constants 

#> 
Param()




New-Variable -Option Constant -Name ERWDC `
	-Value ([System.Security.Principal.SecurityIdentifier]'S-1-5-9') `
	-Description "Enterprise Domain Controllers"
New-Variable -Option Constant -Name AU `
	-Value ([System.Security.Principal.SecurityIdentifier]'S-1-5-11') `
	-Description "Authenticated Users"
New-Variable -Option Constant -Name TOIIS `
	-Value ([System.Security.Principal.SecurityIdentifier]'S-1-5-15') `
	-Description "This Organization (AD)"
New-Variable -Option Constant -Name TOAD `
	-Value ([System.Security.Principal.SecurityIdentifier]'S-1-5-17') `
	-Description "This Organization (IIS)"
New-Variable -Option Constant -Name LS `
	-Value ([System.Security.Principal.SecurityIdentifier]'S-1-5-18') `
	-Description "Local System"
New-Variable -Option Constant -Name A `
	-Value ([System.Security.Principal.SecurityIdentifier]'S-1-5-32-544') `
	-Description "Administrators"
New-Variable -Option Constant -Name U `
	-Value ([System.Security.Principal.SecurityIdentifier]'S-1-5-32-545') `
	-Description "Users"
New-Variable -Option Constant -Name G `
	-Value ([System.Security.Principal.SecurityIdentifier]'S-1-5-32-546') `
	-Description "Guests"
New-Variable -Option Constant -Name PU `
	-Value ([System.Security.Principal.SecurityIdentifier]'S-1-5-32-547') `
	-Description "Power Users"
New-Variable -Option Constant -Name AO `
	-Value ([System.Security.Principal.SecurityIdentifier]'S-1-5-32-548') `
	-Description "Account Operators"
New-Variable -Option Constant -Name SO `
	-Value ([System.Security.Principal.SecurityIdentifier]'S-1-5-32-549') `
	-Description "Server Operators"
New-Variable -Option Constant -Name PO `
	-Value ([System.Security.Principal.SecurityIdentifier]'S-1-5-32-550') `
	-Description "Print Operators"
New-Variable -Option Constant -Name BO `
	-Value ([System.Security.Principal.SecurityIdentifier]'S-1-5-32-551') `
	-Description "Backup Operators"
New-Variable -Option Constant -Name R `
	-Value ([System.Security.Principal.SecurityIdentifier]'S-1-5-32-552') `
	-Description "Replicators"
New-Variable -Option Constant -Name W2k `
	-Value ([System.Security.Principal.SecurityIdentifier]'S-1-5-32-554') `
	-Description "Pre-Windows 2000 Compatible Access"

@(
	@('S-1-5-32-555',"Remote Desktop Users","RDU"),
	@('S-1-5-32-556',"Network Configuration Operators","RCO")
	#@('S-1-5-32-557',"","")
) | % {
	New-Variable -Option Constant -Name $_[2] -Description $_[1] -value ([System.Security.Principal.SecurityIdentifier]$_[0]) -Verbose
}


New-Variable -Option Constant -Name ridA    -Value ([int]"500") # built-in Administrator account
New-Variable -Option Constant -Name ridG    -Value ([int]"501") # built-in Guest account
New-Variable -Option Constant -Name ridKRB  -Value ([int]"502") # KRBTGT
New-Variable -Option Constant -Name ridDA   -Value ([int]"512") # Domain Admins
#New-Variable -Option Constant -Name ridDU   -Value ([int]"513") # Domain Users
#New-Variable -Option Constant -Name ridDG   -Value ([int]"514") # Domain Guests
#New-Variable -Option Constant -Name ridDC   -Value ([int]"515") # Domain Computers
New-Variable -Option Constant -Name ridDC   -Value ([int]"516") # Domain Controllers
New-Variable -Option Constant -Name ridCP   -Value ([int]"517") # Cert Publishers
New-Variable -Option Constant -Name ridSA   -Value ([int]"518") # Schema Admins
New-Variable -Option Constant -Name ridEA   -Value ([int]"519") # Enterprise Admins
New-Variable -Option Constant -Name ridGPCO -Value ([int]"520") # Group Policy Creator Owners
New-Variable -Option Constant -Name ridKA   -Value ([int]"526") # Key Admins
New-Variable -Option Constant -Name ridEKA  -Value ([int]"527") # Enterprise Key Admins
#New-Variable -Option Constant -Name ridGPCO -Value ([int]"553") # 
#New-Variable -Option Constant -Name ridGPCO -Value ([int]"520") # 
#New-Variable -Option Constant -Name ridGPCO -Value ([int]"520") # 
#New-Variable -Option Constant -Name ridGPCO -Value ([int]"520") # 

