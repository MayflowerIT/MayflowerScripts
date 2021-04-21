
#Requires -Module PSDscResources

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
        [Guid]$ProductId = $NetDeployProductId
    )

    Import-DscResource -ModuleName PSDscResources # xPSDesiredStateConfiguration,

    MsiPackage NetDeploy
    {
        ProductId = $ProductId
        Path = $Path
        Arguments = "/qn ARPSYSTEMCOMPONENT=1 DEPLOYID=$DeployId"
    }

    Service NetDeploy
    {
        Name = "Hamachi2Svc"
        StartupType = 'Automatic'
        State = 'Running'

        DependsOn = "[MsiPackage]NetDeploy"
    }

    Import-DscResource -ModuleName NetworkingDsc

    NetAdapterName NetDeploy
    {
        DependsOn = "[Service]NetDeploy"
        NewName = "Miniport"
        DriverDescription = "LogMeIn Hamachi Virtual Ethernet Adapter"
    }

    NetIPInterface NetDeploy4
    {
        DependsOn = "[NetAdapterName]NetDeploy"
        InterfaceAlias = "Miniport"
        AddressFamily = "IPv4"
        InterfaceMetric = 9000
    }

    NetIPInterface NetDeploy6
    {
        DependsOn = "[NetAdapterName]NetDeploy"
        InterfaceAlias = "Miniport"
        AddressFamily = "IPv6"
        InterfaceMetric = 9000
    }

#    NetConnectionProfile NetDeploy
 #   {
  #      InterfaceAlias = "Miniport"
   #     NetworkCategory = "Private"
    #}

    DefaultGatewayAddress NetDeploy4
    {
        DependsOn = "[NetAdapterName]NetDeploy"
        InterfaceAlias = "Miniport"
        AddressFamily = "IPv4"
    }

    DefaultGatewayAddress NetDeploy6
    {
        DependsOn = "[NetAdapterName]NetDeploy"
        InterfaceAlias = "Miniport"
        AddressFamily = "IPv6"
    }

    #Script NetAdapterVisibility.psm1
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
            InterfaceAlias = "Miniport"
            AddressFamily = "IPv4"
            Address = "25.19.19.115","25.17.102.96"
            Validate = $true
        }
    
        DnsServerAddress ITv6
        {
            DependsOn = "[NetDeploy]IT"
            InterfaceAlias = "Miniport"
            AddressFamily = "IPv6"
            Address = '2620:9b::1913:1373','2620:9b::1911:6660'
            Validate = $false
        }
    
        DnsConnectionSuffix IT
        {
            DependsOn = "[DnsServerAddress]ITv4","[DnsServerAddress]ITv6"
            InterfaceAlias = "Miniport"
            ConnectionSpecificSuffix = "Mayflower.IT"
            RegisterThisConnectionsAddress = $false
        }

        NetBios NetDeploy
        {
            DependsOn = "[DnsConnectionSuffix]IT"
            InterfaceAlias = "Miniport"
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