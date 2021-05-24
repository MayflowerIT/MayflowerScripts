#Requires -Module ActiveDirectory

<# scratch get AD users with ACL matching AdminSDHolder #>

# ACL which is enforced during SDPROP process which sets AdminCount to '1'
$asdh = get-acl 'AD:\cn=AdminSDHolder,cn=System,DC=Mayflower,DC=IT'

# All accounts which have AdminCount set to zero-or-greater (i.e., not blank), which are not AD-internals
$ACs = Get-ADUser -Filter {AdminCount -ge '0' -and IsCriticalSystemObject -notlike '*'} -Properties NTSecurityDescriptor -ResultSetSize $null
#([adsisearcher]"(AdminCount=1)").findall()

# accounts with settings as configured, but not neccesarily actually admins...
$MaybeAdmins = $ACs | where {$_.NTSecurityDescriptor.AccessToString -eq $asdh.AccessToString}
# accounts which have inconsistent configuration per SDPROP
$MaybeFormerAdmins = $ACs | where {$_.NTSecurityDescriptor.AccessToString -ne $asdh.AccessToString}
# accounts which were given the ACL and AdminCount, but are later manually marked as not-admin.
$FormerAdmins = $MaybeAdmins | where {$_.AdminCount -lt '1'}

# inconsistent accounts are clearly not being remediated by SDPROP, so set AdminCount to zero.
$MaybeFormerAdmins | Set-ADUser -Replace @{adminCount=0}
# accounts manually set to non-admin should not have the AdminSDHolder ACL anylonger
$FormerAdmins | TODO#: enable inheritance, then clear explicit ACEs

#WRONG WRONG $MaybeAdmins | TODO#: set AdminCount to zero, force SDPROP, then re-run search.
# https://stealthbits.com/blog/fun-with-active-directorys-admincount-attribute/
# SDPROP will *NOT* re-set AdminCount if the ACL already matches!!
if($Force)
{
	Get-ADUser -Filter {AdminCount -ge '0' -and IsCriticalSystemObject -notlike '*'} | Set-ADUser -Replace @{adminCount=0} -passthru | set-acl $whatever

}
# https://github.com/edemilliere/ADSI/blob/master/Invoke-ADSDPropagation.ps1
Invoke-ADSDPropagation -TaskName RunProtectAdminGroupsTask



# https://specopssoft.com/blog/troubleshooting-user-account-permissions-adminsdholder/
# returns *groups* which are protected by SDPROP
foreach ($group in $MaybeAdmins.memberof) { get-adgroup $group -properties adminCount | where {$_.adminCount -ge 0} }
#TODO: default protected groups are all critical system objects, so look for groups which are not ultimately members of any of them which in turn indicates they should have AdminCount decremented and ACL cleared.
#$user.ntsecuritydescriptor.SetAccessRuleProtection($false,$true)
#set-aduser <username> -replace @{ntsecuritydescriptor=$user.ntsecuritydescriptor}



#TODO: remove Account Holders from SDPROP via dsHeuristics
