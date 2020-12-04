#Requires -RunAsAdministrator
#Requires -Module AdmPwd.PS
Import-Module AdmPwd.PS

$cs = Get-ComputerInfo
$ADDS = $cs.CsDomain
$ADDSDN = $($ADDS.split(".") | % { "DC=$_".trim() }) -join ","

$ADDSforest = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()           
$ADDSdomain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()



Update-AdmPwdADSchema
Set-AdmPwdComputerSelfPermission -Identity $ADDSDN
