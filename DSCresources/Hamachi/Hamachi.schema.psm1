#Requires -RunAsAdministrator

$hamachiMSI = "hamachi.msi"
$hamachiURI = "https://secure.logmein.com/$HamachiMSI"

#Import-Module -Name xPSDesiredStateConfiguration

Configuration Hamachi
{   Param(
        [Parameter(Mandatory = $true)]
        [String] $DeployId
    )

    Import-DscResource -ModuleName "PSDesiredStateConfiguration"

$hamachiMSI = "hamachi.msi"
$hamachiURI = "https://secure.logmein.com/$HamachiMSI"

#    xRemoteFile Hamachi
 #   {
  #      DestinationPath = (Join-Path (Join-Path $ENV:SystemRoot "System") $hamachiMSI)
   #     Uri = $hamachiURI
    #}

    Package Hamachi
    {
        ProductId = ''
        Name = "LogMeIn Hamachi"
        Path = $hamachiURI
        Arguments = "DEPLOYID=$DeployId"
    }

    Import-DscResource -ModuleName NetworkingDsc

    NetAdapterName Hamachi
    {
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
}

Configuration IT
{   Param(
        [String[]] $ComputerName = 'localhost'
    )
    Import-DscResource -ModuleName NetworkingDsc

    Node $ComputerName {
        Hamachi IT
        {
            DeployID = "o5edsqqak5ddpmjvcev2xnetvl007pbm83kb7397"
        }

        DnsServerAddress ITv4
        {
            DependsOn = "[Hamachi]IT"
            InterfaceAlias = "Hamachi"
            AddressFamily = "IPv4"
            Address = "25.19.19.115","25.17.102.96"
            Validate = $true
        }
    
        DnsServerAddress ITv6
        {
            DependsOn = "[Hamachi]IT"
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
        }
    }
}



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

