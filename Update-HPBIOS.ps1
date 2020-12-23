$Uptime = Get-HPDeviceUptime
$OneHour = New-TimeSpan -Hours 1

$FirmwareSettings = Get-HPBIOSSettingsList

$FirmwareVersion = Get-HPBIOSVersion -ErrorAction STOP

$FirmwareUpdates = Get-HPBIOSUpdates -ErrorAction STOP

$FirmwareUpdatesApplicable = $FirmwareUpdates | where Ver -ge $FirmwareVersion
$FirmwareUpdateApplicable = $FirmwareUpdatesApplicable[0]

$Softpaqs = Get-Softpaq
$FirmwareSoftpaqs = $Softpaqs | where Name -like '*BIOS*'
$FirmwareSoftpaqsApplicable = $FirmwareSoftpaqs | where Version -eq $FirmwareUpdateApplicable.Ver

$AssetTag = Get-HPDeviceAssetTag
$SerialNumber = Get-HPDeviceSerialNumber

if ($AssetTag -eq $SerialNumber)
{
  #compute asset tag from computer host name.
  
}

Get if BIOS password.
$IsFirmwarePasswordSet = Get-HPBIOSSetupPasswordIsSet

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
		Set-HPBIOSSettingValue -Name "Minimum BIOS Version" -Value $FirmwareVersion
		Set-HPBIOSSettingValue -Name "Automatic BIOS Update Setting" -Value "Disable"
		if BIOS password is blank/unset, then:
			if asset tag begins with 033, then:
				set BIOS password
			if asset tag begins with 040, then:
				set BIOS password
	}



$FirmwareSettings = Get-HPBIOSSettingsList
