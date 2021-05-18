
#Requires -Version 5
#Requires -Module PSDscResources
New-Variable -Option Constant -Name NetAdapterClass -Value ([guid]"4D36E972-E325-11CE-BFC1-08002BE10318")

[Flags()] # https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/managing-bit-flags-part-4
enum DDInstallCharacteristics
{ # https://docs.microsoft.com/en-us/windows-hardware/drivers/network/ddinstall-section-in-a-network-inf-file
	noChange = 0x0
	NCF_Virtual = 0x1
	NCF_Software_Enumerated = 0x2
	NCF_Physical = 0x4
	NCF_Hidden = 0x8
	NCF_NO_SERVICE = 0x10
	NCF_NOT_USER_REMOVABLE = 0x20
	NCF_HAS_UI = 0x80
	NCF_FILTER = 0x400
	NCF_NDIS_PROTOCOL = 0x4000
	NCF_LW_FILTER = 0x40000
}


$AzAutomation = Get-Command -Name "Get-AutomationVariable" -ErrorAction SilentlyContinue
if($AzAutomation)
{
	#$NetDeployID = Get-AutomationVariable -Name "DEPLOYID"
	$NetDeployUri = Get-AutomationVariable -Name "DEPLOYURI"
	$NetDeployProductId = Get-AutomationVariable -Name "DEPLOYPID"
}

Configuration NetDeploy
{   Param(
		[Parameter(Mandatory = $true)]
		[String]$DeployId,
		[Uri]$Path = $NetDeployUri,
		[Guid]$ProductId = $NetDeployProductId,
		[Int]$NdisDeviceType = '0',
		[DDInstallCharacteristics]$Characteristics = [DDInstallCharacteristics]::noChange,
		[String]$AdapterName = "EPN Miniport"
	)
	$svcvndr = $Path.Host.Split(".")[1]
	$svcname = $Path.Segments[1].Split(".")[0]
	$svcbin = Resolve-Path "${ENV:ProgramFiles(x86)}\*\x64\${svcname}-2.exe"

	Import-DscResource -ModuleName PSDscResources # xPSDesiredStateConfiguration,

	MsiPackage NetDeploy
	{
		ProductId = $ProductId
		Path = $Path
		Arguments = "/qn ARPSYSTEMCOMPONENT=1 DEPLOYID=$DeployId"
	}

	Service NetDeploy
	{
		Name = "${svcname}2Svc"
		StartupType = 'Automatic'
		State = 'Running'

		DependsOn = "[MsiPackage]NetDeploy"
	}

	Import-DscResource -ModuleName NetworkingDsc

	NetAdapterName NetDeploy
	{
		DependsOn = "[Service]NetDeploy"
		Status = 'Up' # Ignore disconnected or disabled adapters
		NewName = $AdapterName
		DriverDescription = "$svcvndr $svcname Virtual Ethernet Adapter"
		#IncludeHidden = $true
	}

	NetIPInterface NetDeploy4
	{
		DependsOn = "[NetAdapterBinding]NetDeploy4"
		InterfaceAlias = $AdapterName
		AddressFamily = "IPv4"
		#DHCP = 'Enabled' # a weird with hiding adapter visibility
		InterfaceMetric = 9000
	}

	NetIPInterface NetDeploy6
	{
		DependsOn = "[NetAdapterBinding]NetDeploy6"
		InterfaceAlias = $AdapterName
		AddressFamily = "IPv6"
		InterfaceMetric = 9000
	}

#	NetConnectionProfile NetDeploy
 #   {
  #	  InterfaceAlias = $AdapterName
   #	 NetworkCategory = "Private"
	#}

	DefaultGatewayAddress NetDeploy4
	{
		DependsOn = "[NetAdapterBinding]NetDeploy4"
		InterfaceAlias = $AdapterName
		AddressFamily = "IPv4"
	}

	DefaultGatewayAddress NetDeploy6
	{
		DependsOn = "[NetAdapterBinding]NetDeploy6"
		InterfaceAlias = $AdapterName
		AddressFamily = "IPv6"
	}

	NetAdapterBinding NetDeploy4
	{
		DependsOn = "[NetAdapterName]NetDeploy"
		InterfaceAlias = $AdapterName
		ComponentId	= 'ms_tcpip'
		State		  = 'Enabled'
	}

	NetAdapterBinding NetDeploy6
	{
		DependsOn = "[NetAdapterName]NetDeploy"
		InterfaceAlias = $AdapterName
		ComponentId	= 'ms_tcpip6'
		State		  = 'Enabled'
	}

	Script NetDeploy4
	{
		GetScript = {
			$svcstatus = & "$using:svcbin" --cli
			$IPv4 = Get-NetIPAddress -InterfaceAlias ${using:AdapterName} -AddressFamily IPv4

			$svcstats = $($svcstatus -split '\r?\n').Trim()
			$svcaddr = $svcstats -like 'address*:*' -split ': ' -notlike 'address*' -split '\s' -notlike ''
			return @{
				Result = $svcstatus
				IPAddress = $IPv4
				Version = $svcstats -like 'version*:*' -split ': ' -notlike 'version*'
				pid = $svcstats -like 'pid*:*' -split ': ' -notlike 'pid*'
				status = $svcstats -like 'status*:*' -split ': ' -notlike 'status*'
				clientId = $svcstats -like 'client id*:*' -split ': ' -notlike 'client id*'
				IPv4 = $svcaddr -like '25.*.*.*'
				IPv6 = $svcaddr -like '2620:*:*'
				nickname = $svcstats -like 'nickname*:*' -split ': ' -notlike 'nickname*'
				account = $svcstats -like 'account*:*' -split ': ' -notlike 'account*'
			}
		}
		TestScript = {
			$DHND = [scriptblock]::Create($GetScript).Invoke()

			#TF: Service IP address is the current IP address live on the interface?
			return ($DHND.IPAddress -like $DHND.IPv4)
		}
		SetScript = {
			$DHND = [scriptblock]::Create($GetScript).Invoke()
			$EPND = [scriptblock]::Create($TestScript).Invoke()

			& "$using:svcbin" --cli set-nick ${ENV:ComputerName}

			if($true -eq $EPND)
			{
				New-NetIPAddress -InterfaceDescription $NA.DriverDesc `
					-AddressFamily IPv4 `
					-IPAddress $DHND.IPv4 `
					-PrefixLength 8
			}
			Register-DnsClient
		}

		DependsOn = "[Script]NetAdapterCharacteristics"
	}
	Script NetAdapterCharacteristics
	{
		SetScript = {
			$NA = [scriptblock]::Create($GetScript).Invoke()
			$NAC = $NA.Characteristics

			# DOES NOT WORK B/C NOT BITWISE: ITS ARITHMATIC $NAC += [DDInstallCharacteristics]::NCF_Hidden
			$NAC = $NAC -bor $using:Characteristics # explicitly bitwise

			Set-ItemProperty $NA.PSPath -Name 'Characteristics' -PropertyType Dword -Value $NAC -force
		}
		TestScript = {
			$NA = [scriptblock]::Create($GetScript).Invoke()
			$NAC = $NA.Characteristics

			($NAC -eq ($NAC -bor $using:Characteristics))
		}
		GetScript =  {
			$Description = "*${using:svcname}*"

			$NetworkAdapterClass = [guid]"4D36E972-E325-11CE-BFC1-08002BE10318"
			$RegisteredDriverClasses = "HKLM:\SYSTEM\CurrentControlSet\Control\Class"
			$NetworkAdapterInstances = Join-Path $RegisteredDriverClasses "{$NetworkAdapterClass}"
			$NAK = Join-Path $NetworkAdapterInstances "*"

			$NA = Get-ItemProperty -Path $NAK -ErrorAction SilentlyContinue | 
			Where-Object DriverDesc -like $Description -ErrorAction SilentlyContinue |
			Select-Object DriverDesc, 'Characteristics', PSPath -ErrorAction SilentlyContinue

			return @{ 
				Result = "$($NA | select -ExpandProperty DriverDesc -ErrorAction SilentlyContinue): $($NA | select -ExpandProperty 'Characteristics' -ErrorAction SilentlyContinue)"
				DriverDesc = $NA | select -ExpandProperty DriverDesc -ErrorAction SilentlyContinue
				'Characteristics' = [DDInstallCharacteristics]($NA | select -ExpandProperty 'Characteristics' -ErrorAction SilentlyContinue)
				PSPath = $NA | select -ExpandProperty PSPath  -ErrorAction SilentlyContinue
			}
		}
	}
	Script NetAdapterVisibility
	{
		SetScript = {
			$NA = [scriptblock]::Create($GetScript).Invoke()

			New-ItemProperty $NA.PSPath -Name '*NdisDeviceType' -PropertyType Dword -Value $using:NdisDeviceType -Force
		}
		GetScript =  {
			$Description = "*${using:svcname}*"

			$NetworkAdapterClass = [guid]"4D36E972-E325-11CE-BFC1-08002BE10318"
			$RegisteredDriverClasses = "HKLM:\SYSTEM\CurrentControlSet\Control\Class"
			$NetworkAdapterInstances = Join-Path $RegisteredDriverClasses "{$NetworkAdapterClass}"
			$NAK = Join-Path $NetworkAdapterInstances "*"

			$NA = Get-ItemProperty -Path $NAK -ErrorAction SilentlyContinue | 
			Where-Object DriverDesc -like $Description -ErrorAction SilentlyContinue |
			Select-Object DriverDesc, '*NdisDeviceType', PSPath -ErrorAction SilentlyContinue

			return @{ 
				Result = "$($NA | select -ExpandProperty DriverDesc -ErrorAction SilentlyContinue): $($NA | select -ExpandProperty '*NdisDeviceType' -ErrorAction SilentlyContinue)"
				DriverDesc = $NA | select -ExpandProperty DriverDesc -ErrorAction SilentlyContinue
				'*NdisDeviceType' = $NA | select -ExpandProperty '*NdisDeviceType' -ErrorAction SilentlyContinue
				PSPath = $NA | select -ExpandProperty PSPath  -ErrorAction SilentlyContinue
			}
		} 
		TestScript = {
			$NA = [scriptblock]::Create($GetScript).Invoke()

			return ($NA | select -ExpandProperty '*NdisDeviceType' -ErrorAction SilentlyContinue)
		}

		DependsOn = "[DefaultGatewayAddress]NetDeploy4","[DefaultGatewayAddress]NetDeploy6"
	}
}

<#
Configuration NetDeployIT
{   Param(
		[String[]] $ComputerName = 'localhost'
	)
	Import-DscResource -ModuleName NetworkingDsc

	Node $ComputerName {
		NetDeploy IT
		{
			DeployID = "o5edsqqak5ddpmjvcev2xnetvl007pbm83kb7397"
		}

		DnsServerAddress ITv4
		{
			DependsOn = "[NetDeploy]IT"
			InterfaceAlias = $AdapterName
			AddressFamily = "IPv4"
			Address = "25.19.19.115","25.17.102.96"
			Validate = $true
		}
	
		DnsServerAddress ITv6
		{
			DependsOn = "[NetDeploy]IT"
			InterfaceAlias = $AdapterName
			AddressFamily = "IPv6"
			Address = '2620:9b::1913:1373','2620:9b::1911:6660'
			Validate = $false
		}
	
		DnsConnectionSuffix IT
		{
			DependsOn = "[DnsServerAddress]ITv4","[DnsServerAddress]ITv6"
			InterfaceAlias = $AdapterName
			ConnectionSpecificSuffix = "Mayflower.IT"
			RegisterThisConnectionsAddress = $false
		}

		NetBios NetDeploy
		{
			DependsOn = "[DnsConnectionSuffix]IT"
			InterfaceAlias = $AdapterName
			Setting = "Disable"
}   }   }

if($true -eq $Online)
{
	Set-Location -Path $System16
	NetDeployIT -ComputerName 'localhost'
	Start-DscConfiguration -Path "NetDeployIT" -Wait -Verbose
}

if($false){
$NetDeployMSI = "hamachi.msi"
$NetDeployURI = "https://secure.logmein.com/$NetDeployMSI"

Invoke-WebRequest -uri $NetDeployURI -OutFile $NetDeployMSI 

msiexec /i $NetDeployMSI /qn DEPLOYID="o5edsqqak5ddpmjvcev2xnetvl007pbm83kb7397"

ping -n 10 localhost 
Get-NetAdapter -InterfaceDescription *Hamachi* | Rename-NetAdapter -NewName NetDeploy
ping -n 10 localhost
Set-NetIPInterface -InterfaceAlias NetDeploy -InterfaceMetric 9000
Remove-NetRoute -InterfaceAlias NetDeploy -DestinationPrefix 0.0.0.0/0 -confirm:$false -ErrorAction SilentlyContinue
Remove-NetRoute -InterfaceAlias NetDeploy -DestinationPrefix ::/0 -confirm:$false -ErrorAction SilentlyContinue
Get-DNSClientNRPTRule | Remove-DNSClientNRPTRule -Force
Add-DNSClientNRPTRule -NameServers "25.19.19.115","25.17.102.96" -Namespace  "Mayflower.IT" -Verbose
Add-DNSClientNRPTRule -NameServers "25.19.19.115","25.17.102.96" -Namespace ".Mayflower.IT" -Verbose
}
#>