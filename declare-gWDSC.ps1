﻿#Param(
#    [Switch]$Online = $false
#)
<#
.Description
Desired State for Managed Servers by Mayflower
#>
New-Variable -Option Constant -Name DDP   -Value "{31B2F340-016D-11D2-945F-00C04FB984F9}"
New-Variable -Option Constant -Name DDCP  -Value "{6AC1786C-016F-11D2-945F-00C04FB984F9}"

New-Variable -Option ReadOnly -Name SystemSixteen -Value (Join-Path $env:SystemRoot "System")

Install-Module -Scope AllUsers -Name PSDscResources,xPSDesiredStateConfiguration,ActiveDirectoryDsc
Import-Module -Name MayflowerScripts -ErrorAction STOP

Configuration gW
{
    #Param
    #(
    #    [string[]]$ComputerName='localhost'
    #)

    $OPSINSIGHTS_WS_ID  = Get-AutomationVariable -Name "OPSINSIGHTS_WS_ID"
    $OPSINSIGHTS_WS_KEY = Get-AutomationVariable -Name "OPSINSIGHTS_WS_KEY"
    $OPSINSIGHTS_PID    = Get-AutomationVariable -Name "OPSINSIGHTS_PID" # "774E20C6-9B94-48F2-99C9-8E1FAE17C960" #

    $OIPackageLocalPath = Join-Path $SystemSixteen "MMASetup-AMD64.exe"

    $RslDDP             = Get-AutomationVariable -Name "RSLDDP"
    $RslDDCP            = Get-AutomationVariable -Name "RSLDDCP"
    $RslNL              = Get-AutomationVariable -Name "RSLNL"
    #$RslIso

    $RslDisplayName     = Get-AutomationVariable -Name "RSLDN"
    $RslUri             = Get-AutomationVariable -Name "RSLURI"

    $RslName            = ($RslDisplayName -replace ' ','')
    $RslService         = ($RslName -replace '[aeiou]','')
    $RslBinPath         = Join-Path $SystemSixteen ($RslName + "_x64.exe")
    $RslPath            = Join-Path $env:ProgramData $RslName
    $RslJson            = Join-Path $RslPath ($RslName + ".json")

    $NetDeployID        = Get-AutomationVariable -Name "DEPLOYID"
    #$NetDeployUri       = Get-AutomationVariable -Name "DEPLOYURI"
    #$NetDeployPid       = Get-AutomationVariable -Name "DEPLOYPID"

    Import-DscResource -ModuleName xPSDesiredStateConfiguration # M$-preview, extra features without support
    Import-DscResource -ModuleName PSDscResources # M$-supported, replaces in-box PSDesiredStateConfiguration

    Import-DscResource -ModuleName MayflowerScripts -Name OMSagent # Composite Resource
    Import-DscResource -ModuleName MayflowerScripts -Name NetDeploy # Composite Resource
    #Import-DscResource -ModuleName MayflowerScripts -Name LXmof # Composite Resource

    Import-DscResource -ModuleName ActiveDirectoryDsc # M$-supported
    Import-DscResource -ModuleName xDNSServer # M$-preview
    Import-DscResource -ModuleName xDHCPServer # M$-preview

    Node $AllNodes.Where{$_.Role -eq "ADDS"}.NodeName
    { # Active Directory Domain Services, Domain Controller
        $DomainNameComponents = $Node.DNSName.Split(".")
        $DomainDN = "DC="+ ($DomainNameComponents -join ",DC=")

        xService RslService
        { 
            Name = $RslService
            DisplayName = $RslDisplayName
            State = "Running"
            StartupType = "Automatic"
            Path = "`"$RslBinPath`" /SVC -n $($RslService) /storage `"$RslPath`" /config `"$RslJson`""
            GroupManagedServiceAccount  = (Join-Path "NT Service" $RslService)

            DependsOn = "[Script]RslVersion","[Script]RslJson","[xRemoteFile]RslBin"
        }

#        ADDSDNS DNS
 #       {
  #          DependsOn = "[WindowsFeature]ADDS"
#ensure zone exists, that AD SRV sub-zones exist as zones, &c
#ensure that local DNS server is configured to serve it's static IP, not any others
#ensure conditional forwarder for IT
#ensure forest root set to replicate to all DCs in forest, plus _msdsc, &c.
   #     }

#        ADDSDC NTDS
 #       {
  #          DependsOn = "[NetDeploy]NetDeploy"
#ensure domain `description' is set to company name
#ensure domain `managedBy' is set to EAs
#ensure domain built-in Administrators is: built-in Administrator, DAs, EAs, EDCs
#ensure DA = "Information Services & Technology", EA = "Information Security & Technology"
   #     }
# How do AD Sites/Subnets related to DHCP Scopes?
#ADDSDHCP
#{
#ensure scopes exist, DCs have DHCP, set to sync relationship, &c.
#}

<#
        ADReplicationSiteLink Hamachi
        {
            Name                          = 'Hamachi'
            Description                   = 'LogMeIn Hamachi'
            SitesIncluded                 = 'Hamachi'
            Cost                          = 9000
            ReplicationFrequencyInMinutes = 20
            OptionChangeNotification      = $true
            OptionTwoWaySync              = $true
            OptionDisableCompression      = $false
            Ensure                        = 'Present'

            DependsOn = "[ADReplicationSite]Hamachi"
        }

        ADReplicationSite Hamachi
        {
            Ensure                     = 'Present'
            Name                       = 'Hamachi'
            RenameDefaultFirstSiteName = $true

            DependsOn = "[Service]NTDS"
        }

        ADReplicationSubnet Hamachi
        {
            Name        = '25.0.0.0/8'
            Site        = 'Hamachi'
            Location    = 'VPN'
            Description = 'LogMeIn Hamachi'

            DependsOn = "[ADReplicationSite]Hamachi"
        }
#>
        Script PublishStaticAddresses
        {
            GetScript = { @{ 
                Result = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\DNS\Parameters -Name PublishAddresses -ErrorAction SilentlyContinue
                CurrentIP = Get-NetIPAddress -PrefixOrigin Manual -AddressFamily IPv4 -ErrorAction SilentlyContinue
            } }
            TestScript = {
                $State = [scriptblock]::Create($GetScript).Invoke()
                #$MyIP = $State['CurrentIP'].IPAddress
                $MyIP = Get-NetIPAddress -PrefixOrigin Manual -AddressFamily IPv4 -ErrorAction SilentlyContinue | select -ExpandProperty IPAddress
                #$PublishedIP = $State['Result'] | select -ExpandProperty PublishAddresses
                $PublishedIP = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\DNS\Parameters -Name PublishAddresses -ErrorAction SilentlyContinue | select -ExpandProperty PublishAddresses

                #foreach ($IP in $State['CurrentIP'])
                #{
                    #
                #}

                if (($null -ne "$MyIP") -and ("$MyIP" -like "$PublishedIP"))
                { return $true }
                else
                { return $false }
            }
            SetScript = {
                $MyIP = Get-NetIPAddress -PrefixOrigin Manual -AddressFamily IPv4
                
                if($MyIP.IPAddress)
                {
                    Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\DNS\Parameters -Name PublishAddresses -Type String -Value $MyIP.IPAddress
                    Remove-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\DNS\Parameters -Name ListenAddresses -ErrorAction SilentlyContinue
                }
                Register-DnsClient
            }

            DependsOn = "[Service]DNS"
        }
<#
        foreach ($SiteName in $Node.Sites.Keys)
        {
            $Site = $Node.Sites.$SiteName
            $SiteIndex = $Site.SiteIndex
            ADReplicationSite $SiteName
            {
                Name = $SiteName
                DependsOn = "[Service]NTDS"
            }

            foreach ($Subnet in $ConfigurationData.ProgramData.Subnets.Keys)
            {
                $SubnetId = "10."+$SiteIndex+"."+$Subnet+".0"
                ADReplicationSubnet $SiteName+$Subnet
                {
                    Name = $SubnetId+"/24"
                    Site = $SiteName
                    Description = $ConfigurationData.ProgramData.Subnets.$Subnet.Description
                }
                #xDHCPServerScope $SiteName+$Subnet
                #{
                #    ScopeId = $SubnetId
                #    ScopeName = $ConfigurationData.ProgramData.Subnets.$Subnet.Name
                #}
            }
        }

        ADReplicationSubnet $Node.NodeName
        {
            Name = '10.'+($Node.ClientIndex)+'.32.0/20'
            Site = $Node.NodeName
            Description = $Node.Description
            Location = $Node.Location

            DependsOn = "[ADReplicationSite]$($Node.NodeName)"
        }
#>
        Group Administrators
        {
            GroupName='S-1-5-32-544'
            Ensure= 'Present'
            MembersToInclude= 'S-1-5-9'

            DependsOn = "[Service]NTDS","[WindowsFeature]ADDSt"
        }

        ADManagedServiceAccount AGPM
        {
            ServiceAccountName = 'AGPM'
            AccountType = 'Group'
            DisplayName = 'Advanced Group Policy Management'
            #Description = ""

            DependsOn = "[ADKDSKey]KDS"
        }

        #Group AGPM
        #{
        #    GroupName= (Join-Path $Node.NodeName "Group Policy Creator Owners")
        #    MembersToInclude = (Join-Path $Node.NodeName 'AGPM$')

        #    DependsOn = "[ADManagedServiceAccount]AGPM"
        #}

        ADManagedServiceAccount AADC
        {
            ServiceAccountName = 'AADC'
            AccountType = 'Group'
            DisplayName = 'Azure Active Directory Connect'
            #Description = ""

            #ManagedPasswordPrincipals = 'S-1-5-9'

            DependsOn = "[ADKDSKey]KDS"
        }

        xDnsServerConditionalForwarder IT
        {
            Name = "Mayflower.IT"
            MasterServers = "25.19.19.115","25.17.102.96"
            ReplicationScope = "Forest"

            DependsOn = "[Service]DNS","[WindowsFeature]DNSt"
        }

        xDnsServerForwarder DNS
        {
            IsSingleInstance = 'Yes'
            IPAddresses      = @('8.8.8.8', '8.8.4.4', '9.9.9.9', '1.0.0.1', '1.1.1.1')
            UseRootHint      = $true
            EnableReordering = $true
            Timeout = 5

            DependsOn = "[Service]DNS","[WindowsFeature]DNSt"
        }

        xDnsServerADZone ARPA
        {
            Name             = ($Node.ClientIndex)+'.10.in-addr.arpa'
            DynamicUpdate    = 'Secure'
            ReplicationScope = 'Forest'
            Ensure           = 'Present'

            DependsOn = "[Service]DNS","[WindowsFeature]DNSt"
        }
        xDnsServerADZone xARPA
        {
            Name             = '.10.in-addr.arpa'
            DynamicUpdate    = 'Secure'
            ReplicationScope = 'Forest'
            Ensure           = 'Absent'

            DependsOn = "[Service]DNS","[WindowsFeature]DNSt"
        }

        Service DNS
        {
            Name = "DNS"
            State = "Running"
            StartupType = "Automatic"

            DependsOn = "[WindowsFeature]DNS","[Service]NTDS"
        }

        Service NTDS
        {
            Name = "NTDS"
            State = "Running"
            StartupType = "Automatic"

            DependsOn = "[WindowsFeature]ADDS"
        }

        ADKDSKey KDS
        {
            Ensure = "Present"
            EffectiveTime = '5/1/2018 00:00'
            AllowUnsafeEffectiveTime = $true

            DependsOn = "[Service]NTDS","[WindowsFeature]ADDSt"
        }

        WindowsFeature ADDS
        {
            Name = "AD-Domain-Services"
            Ensure = "Present"

            DependsOn = "[NetDeploy]ADDS"
        }

        WindowsFeature ADDSt
        {
            Name = "RSAT-AD-PowerShell"
            Ensure = "Present"
        }

        WindowsFeature DNS
        {
            Name = "DNS"
            Ensure = "Present"

            DependsOn = "[WindowsFeature]ADDS"
        }

        WindowsFeature DNSt
        {
            Ensure = 'Present'
            Name   = 'RSAT-DNS-Server'
        }

        Script RslVersion
        { # Stop the service if the version is old; otherwise, xRemoteFile won't be able to update it.
            GetScript = {
                return @{ 'Result' = (Get-Command $using:RslBinPath).Version }
                }
            SetScript = {
                Stop-Service -Name $using:RslService -ErrorAction SilentlyContinue
                }
            TestScript = {
                if (Test-Path -PathType Leaf -Path $using:RslBinPath)
                {
                    [version]$RslVersionInstalled = (Get-Command $using:RslBinPath).Version
                    [version]$RslVersionKnown = "2.6.4"
                    if ($RslVersionInstalled -lt $RslVersionKnown)
                    { # If installed version is less than the intended version, then fail the test.
                        return $false 
                    }
                    else
                    { return $true }
                } else { return $false }
                }
        }

        Script RslJson
        { # Test if configuration file exists.
            GetScript = {
                return @{ 'Result' = (Get-Content $using:RslJson) }
                }
            SetScript = {
                # Create the file, set the values
                return $false
                }
            TestScript = {
                # Check if exists with minimum values; $true = already set; $false = needs SetScript 
                Test-Path -PathType Leaf -Path $using:RslJson
                }
            DependsOn = "[File]RslPath" #,"[Script]RslVersion"
        }

        File RslPath
        { # Ensure configuration Storage Path exists.
            DestinationPath = $RslPath
            Type = 'Directory'
        }

        #NTFSAccessControl RslConfig
        # Ensure correct permissions set on configuration Storage Path.

        xRemoteFile RslBin
        { 
            Uri = $RslUri
            DestinationPath = $RslBinPath

            DependsOn = "[Script]RslVersion"

            MatchSource = $false # THIS IS A HACK TO AVOID ACCESS DENIED / IN USE BY ANOTHER PROCESS
        }

        NetDeploy ADDS
        {
            DeployId = $NetDeployID
        }

        OMSagent OMSnode
        {
            OPSINSIGHTS_PID    = $OPSINSIGHTS_PID
            OPSINSIGHTS_WS_ID  = $OPSINSIGHTS_WS_ID
            OPSINSIGHTS_WS_KEY = $OPSINSIGHTS_WS_KEY
        }

    }

    #Node ADDSTH
    #{ # Azure AD Connect
    #}



    Node OMSnode
    { # *just* logging...
        OMSagent OMSnode
        {
            OPSINSIGHTS_PID    = $OPSINSIGHTS_PID
            OPSINSIGHTS_WS_ID  = $OPSINSIGHTS_WS_ID
            OPSINSIGHTS_WS_KEY = $OPSINSIGHTS_WS_KEY
        }
    }
}

if ($true -eq $Online)
{
	Install-Module -Scope AllUsers -Name Az
	Connect-AzAccount
	$MySubscription = "c42f346f-e80f-48e5-ad8e-30a25c669714" # Assigned Partner Benefit
	Set-AzContext -Subscription $MySubscription
	$MyResourceGroup = 'Kalimdor'
	$MyAutomationAccount = 'Drustvar'
	
	Import-AzAutomationDscConfiguration -SourcePath $PSCommandPath -ResourceGroupName $MyResourceGroup -AutomationAccountName $MyAutomationAccount -Published

    $gWdsc = Import-PowerShellDataFile -Path "$PSScriptRoot\PrivateData\gWadds.psd1"
	Start-AzAutomationDscCompilationJob -ResourceGroupName $MyResourceGroup -AutomationAccountName $MyAutomationAccount -ConfigurationName 'gW' -ConfigurationData $gWdsc
	#Import-AzAutomationDscNodeConfiguration -AutomationAccountName $MyAutomationAccount -ResourceGroupName $MyResourceGroup -ConfigurationName 'MyNodeConfiguration' -Path 'C:\MyConfigurations\TestVM1.mof'
}

#https://docs.microsoft.com/en-us/azure/automation/automation-dsc-compile#manage-configurationdata-when-compiling-configurations-in-azure-automation
# https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/wmf/whats-new/dsc-improvements?view=powershell-7.1#dsc-module-and-configuration-signing-validations
# https://devblogs.microsoft.com/powershell/separating-what-from-where-in-powershell-dsc/
# https://docs.microsoft.com/en-us/azure/automation/compose-configurationwithcompositeresources#compose-a-configuration
# https://docs.microsoft.com/en-us/powershell/scripting/dsc/tutorials/bootstrapdsc?view=powershell-5.1
# https://docs.microsoft.com/en-us/azure/automation/shared-resources/modules#internal-cmdlets
# 
