
<# scratch for DSC ideas #>

New-Variable -Option ReadOnly -Name SystemSixteen -Value (Join-Path $env:SystemRoot "System")
$VMwT = Join-Path $SystemSixteen "VMware-tools.exe"

Configuration VMwareTools
{	Param(
		[String]
		$Path = $VMwT,
		[Uri]
		$Uri = "https://packages.vmware.com/tools/esx/latest/windows/x64/VMware-tools-11.2.5-17337674-x86_64.exe",
		[Guid]
		$ProductID = ""
	)

	Import-DscResource xPSDesiredStateConfiguration

	xRemoteFile VMwareTools
	{
		DestinationPath = $Path
		Uri = $Uri
	}

	xPackage VMwareTools
	{
		Name = "VMware Tools"
		Path = $Path
		Arguments = '/S /v "/qn REBOOT=R ADDLOCAL=ALL"'
		IgnoreReboot = $true
	}
}
