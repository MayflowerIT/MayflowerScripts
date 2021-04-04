#Reqiores -Modules HPCMSL
#Requires -RunAsAdministrator

$Uptime = Get-HPDeviceUptime
$OneHour = New-TimeSpan -Hours 1

$FirmwareSettings = Get-HPBIOSSettingsList

$FirmwareVersion = Get-HPBIOSVersion -ErrorAction STOP

$FirmwareUpdates = Get-HPBIOSUpdates -ErrorAction STOP

$FirmwareUpdatesApplicable = $FirmwareUpdates | where Ver -ge $FirmwareVersion
# '-ge' so that our list isn't empty
$FirmwareUpdateApplicable = $FirmwareUpdatesApplicable[0]

$Softpaqs = Get-Softpaq
$FirmwareSoftpaqs = $Softpaqs | where Name -like '*BIOS*' -or Name -like '*Firmware*'
$FirmwareSoftpaqsApplicable = $FirmwareSoftpaqs | where Version -eq $FirmwareUpdateApplicable.Ver

$AssetTag = Get-HPDeviceAssetTag
$SerialNumber = Get-HPDeviceSerialNumber

if ($AssetTag -eq $SerialNumber)
{
  #compute asset tag from computer host name.
  
}

$FirmwarePasswordIsSet = Get-HPBIOSSetupPasswordIsSet

$FirmwarePassword = Read-Host -AsSecureString -Prompt "Firmware Configuration Password"

If BIOS password is unknown, then fail.

If any BIOS update is newer than current BIOS version, then:
$FirmwareUpdateApplicable.ver -gt $FirmwareVersion
if ($uptime.Uptime -lt $OneHour)
	{
		suspend BitLocker, or fail.
		if BIOS password and BIOS password is known, then:
			install BIOS update, then force immediate reboot.
	}

If BIOS version is current and no Windows Update is in progress, then:
$FirmwareUpdateApplicable.ver -eq $FirmwareVersion
	{
		un-suspend BitLocker.
		Set-HPBIOSSettingValue -Password ([System.Net.NetworkCredential]::new('', $FirmwarePassword).Password) `
			-Name "Minimum BIOS Version" -Value $FirmwareVersion
		Set-HPBIOSSettingValue -Password ([System.Net.NetworkCredential]::new('', $FirmwarePassword).Password) `
			-Name "Automatic BIOS Update Setting" -Value "Disable"
		if BIOS password is blank/unset, then:
			if asset tag begins with 033, then:
				set BIOS password
			if asset tag begins with 040, then:
				set BIOS password
	}



