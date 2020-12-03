# tst

$SvcNameFull= "Mayflower Sync"

$svcnameshort= $SvcNameFull -replace ' ',''
$svcname = $SvcNameShort -replace '[aeiou]',''
$syncbinpath = "System\${svcnameshort}_x64.exe"
$storageRoot = "$env:SystemDrive\Sync"
$storagePath = "$env:ProgramData\${svcnameshort}"

$resiliourl = "https://download-cdn.resilio.com/stable/windows64/Resilio-Sync_x64.exe"

Start-Service BITS
Import-Module BitsTransfer

Start-BitsTransfer -Source $resiliourl -Destination "$env:SystemRoot\$syncbinpath" -TransferType Download

New-Service -Name $svcname -BinaryPathName "`"%SystemRoot%\$syncbinpath`" /SVC -n $($svcname) /storage `"%ProgramData%\${svcnameshort}`" /config `"%ProgramData%\${svcnameshort}\${svcnameshort}.json`"" -DisplayName "${svcnamefull}" -StartupType Automatic -ErrorAction SilentlyContinue
$service = gwmi win32_service -filter "name='$($svcname)'"
$service.change($null,$null,$null,$null,$null,$null,"NT Service\$($svcname)",$null)


md $storageRoot -ErrorAction SilentlyContinue
icacls $storageRoot /setowner "NT Service\$svcname"
icacls $storageRoot /grant "NT Service\${svcname}:(OI)(CI)(F)"
md $storagePath -ErrorAction SilentlyContinue
icacls $storagePath /setowner "NT Service\$svcname"
icacls $storagePath /grant "NT Service\${svcname}:(OI)(CI)(F)"
(Get-Content $PSScriptRoot\${svcnameshort}.json).replace('SYNC_DEVICE_NAME', "$env:ComputerName") | Set-Content $env:ProgramData\${svcnameshort}\${svcnameshort}.json
