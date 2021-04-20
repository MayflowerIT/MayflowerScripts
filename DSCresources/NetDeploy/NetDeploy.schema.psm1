
#Requires -Module PSDscResources
$PSDefaultParameterValues=@{ "gW:NetDeployID" = {{Get-AutomationVariable -Name "DEPLOYID"}} }
$PSDefaultParameterValues=@{ "gW:Path" = {{Get-AutomationVariable -Name "DEPLOYURI"}} }
$PSDefaultParameterValues=@{ "gW:ProductId" = {{Get-AutomationVariable -Name "DEPLOYPID"}} }

Configuration NetDeploy
{   Param(
        [Parameter(Mandatory = $true)]
        [String]$DeployId,
        [Uri]$Path,
        [Guid]$ProductId
    )

    Import-DscResource -ModuleName PSDscResources # xPSDesiredStateConfiguration,

    MsiPackage Hamachi
    {
        ProductId = $ProductId
        Path = "https://secure.logmein.com/hamachi.msi"
        Arguments = "/qn ARPSYSTEMCOMPONENT=1 DEPLOYID=$DeployId"
    }

    Service Hamachi
    {
        Name = "Hamachi2Svc"
        StartupType = 'Automatic'
        State = 'Running'

        DependsOn = "[MsiPackage]Hamachi"
    }

    Import-DscResource -ModuleName NetworkingDsc

    NetAdapterName Hamachi
    {
        DependsOn = "[Service]Hamachi"
        NewName = "Hamachi"
        DriverDescription = "LogMeIn Hamachi Virtual Ethernet Adapter"
    }

    NetIPInterface Hamachi4
    {
        DependsOn = "[NetAdapterName]Hamachi"
        InterfaceAlias = "Hamachi"
        AddressFamily = "IPv4"
        InterfaceMetric = 9000
    }

    NetIPInterface Hamachi6
    {
        DependsOn = "[NetAdapterName]Hamachi"
        InterfaceAlias = "Hamachi"
        AddressFamily = "IPv6"
        InterfaceMetric = 9000
    }

#    NetConnectionProfile Hamachi
 #   {
  #      InterfaceAlias = "Hamachi"
   #     NetworkCategory = "Private"
    #}

    DefaultGatewayAddress Hamachi4
    {
        DependsOn = "[NetAdapterName]Hamachi"
        InterfaceAlias = "Hamachi"
        AddressFamily = "IPv4"
    }

    DefaultGatewayAddress Hamachi6
    {
        DependsOn = "[NetAdapterName]Hamachi"
        InterfaceAlias = "Hamachi"
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
            InterfaceAlias = "Hamachi"
            AddressFamily = "IPv4"
            Address = "25.19.19.115","25.17.102.96"
            Validate = $true
        }
    
        DnsServerAddress ITv6
        {
            DependsOn = "[NetDeploy]IT"
            InterfaceAlias = "Hamachi"
            AddressFamily = "IPv6"
            Address = '2620:9b::1913:1373','2620:9b::1911:6660'
            Validate = $false
        }
    
        DnsConnectionSuffix IT
        {
            DependsOn = "[DnsServerAddress]ITv4","[DnsServerAddress]ITv6"
            InterfaceAlias = "Hamachi"
            ConnectionSpecificSuffix = "Mayflower.IT"
            RegisterThisConnectionsAddress = $false
        }

        NetBios Hamachi
        {
            DependsOn = "[DnsConnectionSuffix]IT"
            InterfaceAlias = "Hamachi"
            Setting = "Disable"
}   }   }

if($true -eq $Online)
{
    Set-Location -Path $System16
    NetDeployIT -ComputerName 'localhost'
    Start-DscConfiguration -Path "NetDeployIT" -Wait -Verbose
}

if($false){
$hamachiMSI = "hamachi.msi"
$hamachiURI = "https://secure.logmein.com/$HamachiMSI"

Invoke-WebRequest -uri $hamachiURI -OutFile $hamachiMSI 

msiexec /i $hamachiMSI /qn DEPLOYID="o5edsqqak5ddpmjvcev2xnetvl007pbm83kb7397"

ping -n 10 localhost 
Get-NetAdapter -InterfaceDescription *Hamachi* | Rename-NetAdapter -NewName Hamachi
ping -n 10 localhost
Set-NetIPInterface -InterfaceAlias Hamachi -InterfaceMetric 9000
Remove-NetRoute -InterfaceAlias Hamachi -DestinationPrefix 0.0.0.0/0 -confirm:$false -ErrorAction SilentlyContinue
Remove-NetRoute -InterfaceAlias Hamachi -DestinationPrefix ::/0 -confirm:$false -ErrorAction SilentlyContinue
Get-DNSClientNRPTRule | Remove-DNSClientNRPTRule -Force
Add-DNSClientNRPTRule -NameServers "25.19.19.115","25.17.102.96" -Namespace  "Mayflower.IT" -Verbose
Add-DNSClientNRPTRule -NameServers "25.19.19.115","25.17.102.96" -Namespace ".Mayflower.IT" -Verbose
}
#>