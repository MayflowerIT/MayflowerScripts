#Requires -RunAsAdministrator



if ($localUsers = Get-LocalUser -Name Mayflower,ASiUser,LogMeInRemoteUser)
{
    Disable-LocalUser $localUsers -Verbose
}
