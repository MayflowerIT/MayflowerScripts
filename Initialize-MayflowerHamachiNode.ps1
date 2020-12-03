<# Init Mayflower Hamachi #>

#Requires -RunAsAdministrator

$hamachiURI = "HTTPS://Secure.LogMeIn.com/Hamachi.msi"
$hamachiMSI = "$temp\Hamachi.msi"
$hamachiNET = "o5edsqqak5ddpmjvcev2xnetvl007pbm83kb7397"


[ValidatePattern("\w+")]$newComputerName = Read-Host -prompt "Enter this computer's new name" -ErrorAction STOP


Invoke-WebRequest -Uri $hamachiURI -OutFile $hamachiMSI
Start-Process -wait -NoNewWindow MSIEXEC -ArgumentList "/i","`"$hamachiMSI`"","/qn","DEPLOYID=$hamachiNET","XXX_DESCRIPTION=$newComputerName" -ErrorAction STOP


Write-Host "This device has been joined to Mayflower's Hamachi network. `
            Make sure to assign this device to the apprirate subnets before continuing."
Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

Add-DnsClientNrptRule -Namespace  "Mayflower.IT" -NameServers "25.19.19.115","25.17.102.96" 
Add-DnsClientNrptRule -Namespace ".Mayflower.IT" -NameServers "25.19.19.115","25.17.102.96" 



do {
  Write-Host "Waiting for IT reachability..."
  sleep 1
} until(Test-NetConnection "Mayflower.IT" -Port 53 | ? { $_.TcpTestSucceeded } )


Add-Computer -DomainName "Mayflower.IT" -Credential (Get-Credential) -NewName $newComputerName

Start-Process -Wait -NoNewWindow "GPUPDATE" 

Restart-Computer

