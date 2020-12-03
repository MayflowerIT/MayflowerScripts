#Requires -RunAsAdministrator

if (-not (test-path env:LMIDEPLOYID)) 
{ 
    $env:LMIDEPLOYID = '01_7xa4jho24dqv5v4bfjhwasvsds7nyyrfb7fyb'
}

$lmimsiurl = "HTTPS://SECURE.LOGMEIN.COM/LOGMEIN.MSI"
$lmimsifile = "$ENV:SystemRoot\System\$(Split-Path -Path $lmimsiurl -Leaf)"

$command = "curl -Uri $lmimsiurl -OutFile $lmimsifile"
$bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
$encodedCommand = [Convert]::ToBase64String($bytes)

$w32c = Get-WmiObject -Class Win32_OperatingSystem
$lmidesc = $w32c.description

Invoke-WebRequest -Uri $lmimsiurl -OutFile $lmimsifile -ErrorAction STOP
msiexec /i $lmimsifile /qn "DEPLOYID=$env:LMIDEPLOYID" INSTALLMETHOD=5 FQDNDESC=0 LMIDESCRIPTION="$ENV:ComputerName: $lmidesc"

