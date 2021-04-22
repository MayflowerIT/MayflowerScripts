
#Requires -Module PSDscResources
New-Variable -Option Constant -Name NetAdapterClass -Value ([guid]"4D36E972-E325-11CE-BFC1-08002BE10318")

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
        [String]$AdapterName = "EPN Miniport"
    )
    $svcname = $Path.Segments[1].Split(".")[0]

    Import-DscResource -ModuleName PSDscResources # xPSDesiredStateConfiguration,

    MsiPackage NetDeploy
    {
        ProductId = $ProductId
        Path = $Path
        Arguments = "/qn ARPSYSTEMCOMPONENT=1 DEPLOYID=$DeployId"
    }

    Service NetDeploy
    {
        Name = "$($svcname)2Svc"
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
        DriverDescription = "LogMeIn $svcname Virtual Ethernet Adapter"
    }

    NetIPInterface NetDeploy4
    {
        DependsOn = "[NetAdapterBinding]NetDeploy4"
        InterfaceAlias = $AdapterName
        AddressFamily = "IPv4"
        InterfaceMetric = 9000
    }

    NetIPInterface NetDeploy6
    {
        DependsOn = "[NetAdapterBinding]NetDeploy6"
        InterfaceAlias = $AdapterName
        AddressFamily = "IPv6"
        InterfaceMetric = 9000
    }

#    NetConnectionProfile NetDeploy
 #   {
  #      InterfaceAlias = $AdapterName
   #     NetworkCategory = "Private"
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
        ComponentId    = 'ms_tcpip'
        State          = 'Enabled'
    }

    NetAdapterBinding NetDeploy6
    {
        DependsOn = "[NetAdapterName]NetDeploy"
        InterfaceAlias = $AdapterName
        ComponentId    = 'ms_tcpip6'
        State          = 'Enabled'
    }

    Script NetDeploy
    {
        SetScript = {
            $navKey = "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{$using:NetAdapterClass}\*"

            $net = Get-ItemProperty -Path $navKey -ErrorAction SilentlyContinue | 
                Where-Object { $_.DriverDesc -like "*$using:svcname*" } |
                    Select-Object DriverDesc, PSPath
            
            New-ItemProperty $net.PSPath -name '*NdisDeviceType' -propertytype dword -value 1 | Out-Null
            Register-DnsClient
        }
        GetScript = {
            $navKey = "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{$using:NetAdapterClass}\*"

            $net = Get-ItemProperty -Path $navKey -ErrorAction SilentlyContinue | 
                Where-Object { $_.DriverDesc -like "*$using:svcname*" } |
                    Select-Object DriverDesc, PSPath

            return @{ Result = $net }
        }
        TestScript = {
            $navKey = "Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{$using:NetAdapterClass}\*"

            $net = Get-ItemProperty -Path $navKey -ErrorAction SilentlyContinue | 
                Where-Object { $_.DriverDesc -like "*$using:svcname*" } |
                    Select-Object DriverDesc, PSPath

            return (Get-ItemProperty -Path $net.PSPath -Name '*NdisDeviceType')
        }

        DependsOn = "[DefaultGatewayAddress]NetDeploy4","[DefaultGatewayAddress]NetDeploy4"
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