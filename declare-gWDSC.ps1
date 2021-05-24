
#Requires -Module MayflowerScripts
#Requires -Module PSDscResources
#Requires -Module xPSDesiredStateConfiguration
#Requires -Module ActiveDirectoryDsc
#Requires -Module xDNSServer
#Requires -Module xDHCPServer

$BlankSecureString = New-Object System.Security.SecureString
$NTSystem = New-Object System.Management.Automation.PSCredential ("NT Authority\SYSTEM", $BlankSecureString)


New-Variable -Option Constant -Name DDP    -Value ([guid]"31B2F340-016D-11D2-945F-00C04FB984F9")
New-Variable -Option Constant -Name DDCP   -Value ([guid]"6AC1786C-016F-11D2-945F-00C04FB984F9")

Import-Module ./gWsids.psm1

New-Variable -Option ReadOnly -Name SystemSixteen -Value (Join-Path $env:SystemRoot "System")

if ($true -eq $Online)
{
    Install-Module -Scope AllUsers -Name PSDscResources,xPSDesiredStateConfiguration,ActiveDirectoryDsc
    Import-Module -Name MayflowerScripts -ErrorAction STOP
}

$AzAutomation = Get-Command -Name "Get-AutomationVariable" -ErrorAction SilentlyContinue
if($AzAutomation)
{
    $OPSINSIGHTS_WS_ID = Get-AutomationVariable -Name "OPSINSIGHTS_WS_ID"
    $OPSINSIGHTS_WS_KEY = Get-AutomationVariable -Name "OPSINSIGHTS_WS_KEY"
    $OPSINSIGHTS_PID = Get-AutomationVariable -Name "OPSINSIGHTS_PID"
    $RslDisplayName = Get-AutomationVariable -Name "RSLDN"
    $RslUri = Get-AutomationVariable -Name "RSLURI"
    $NetDeployID = Get-AutomationVariable -Name "DEPLOYID"
}

<#
.Description
Desired State for Managed Servers by Mayflower
#>
Configuration gW
{   Param(
        [ValidateNotNullOrEmpty()]
        [String]
        $OPSINSIGHTS_WS_ID = $OPSINSIGHTS_WS_ID,

        [ValidateNotNullOrEmpty()]
        [String]
        $OPSINSIGHTS_WS_KEY = $OPSINSIGHTS_WS_KEY,

        [ValidateNotNullOrEmpty()]
        [Guid]
        $OPSINSIGHTS_PID = $OPSINSIGHTS_PID,

        #[String]$RslDDP             = Get-AutomationVariable -Name "RSLDDP",
        #[String]$RslDDCP            = Get-AutomationVariable -Name "RSLDDCP",
        #[String]$RslNL              = Get-AutomationVariable -Name "RSLNL",
        #[String]$RslIso,

        [ValidateNotNullOrEmpty()]
        [String]
        $RslDisplayName = $RslDisplayName,
        [ValidateNotNullOrEmpty()]
        [Uri]
        $RslUri = $RslUri,

        [ValidateNotNullOrEmpty()]
        [String]
        $NetDeployID = $NetDeployID
        #[Uri]$NetDeployUri              = Get-AutomationVariable -Name "DEPLOYURI"
        #[Guid]$NetDeployPid             = Get-AutomationVariable -Name "DEPLOYPID"
    )#Param
#>
<#
$OPSINSIGHTS_WS_ID = Get-AutomationVariable -Name "OPSINSIGHTS_WS_ID"
$OPSINSIGHTS_WS_KEY = Get-AutomationVariable -Name "OPSINSIGHTS_WS_KEY"
$OPSINSIGHTS_PID = Get-AutomationVariable -Name "OPSINSIGHTS_PID"
$RslDisplayName = Get-AutomationVariable -Name "RSLDN"
$RslUri = Get-AutomationVariable -Name "RSLURI"
$NetDeployID = Get-AutomationVariable -Name "DEPLOYID"
<##>
    #$OIPackageLocalPath = Join-Path $SystemSixteen "MMASetup-AMD64.exe"
    $RslName            = ($RslDisplayName -replace ' ','')
    $RslService         = ($RslName -replace '[aeiou]','')
    $RslBinPath         = Join-Path $SystemSixteen ($RslName + "_x64.exe")
    $RslPath            = Join-Path $env:ProgramData $RslName
    $RslJson            = Join-Path $RslPath ($RslName + ".json")

    Import-DscResource -ModuleName xPSDesiredStateConfiguration # M$-preview, extra features without support
    Import-DscResource -ModuleName PSDscResources # M$-supported, replaces in-box PSDesiredStateConfiguration

    Import-DscResource -ModuleName MayflowerScripts -Name OMSagent # Composite Resource
    Import-DscResource -ModuleName MayflowerScripts -Name NetDeploy # Composite Resource
    #Import-DscResource -ModuleName MayflowerScripts -Name LXmof # Composite Resource

    Import-DscResource -ModuleName ActiveDirectoryDsc # M$-supported
    Import-DscResource -ModuleName xDNSServer # M$-preview
    Import-DscResource -ModuleName xDHCPServer # M$-preview

    Node $AllNodes.Where{$_.Role -eq "ADDS"}.NodeName
    #Node $AllNodes.NodeName
    { # Active Directory Domain Services, Domain Controller
        $DomainComponents = $Node.DNSName.Split(".")
        $NodeDistinguishedName = "DC="+ ($DomainComponents -join ",DC=")

        User ASiUser
        {   #DomainName = $Node.DNSName
            Username = "asiuser"
            DisplayName = "ASi Networks, Inc."
            #CommonName
            Disabled = $true
            #RestoreFromRecycleBin = $true
            #Ensure = 'Absent'
        }

        User ASiAdmin
        {   #DomainName = $Node.DNSName
            Username = "asiadmin"
            DisplayName = "ASi Networks, Inc."
            #CommonName
            Disabled = $true
            #RestoreFromRecycleBin = $true
            #Ensure = 'Absent'
        }

        User Mayflower
        {   #DomainName = $Node.DNSName
            Username = "mayflower"
            DisplayName = "Mayflower IS&T"
            #CommonName
            Disabled = $true
            #RestoreFromRecycleBin = $true
            #Ensure = 'Absent'
        }

        User Binovia
        {   #DomainName = $Node.DNSName
            Username = "binovia"
            DisplayName = "Binovia Corp."
            #CommonName
            Disabled = $true
            #RestoreFromRecycleBin = $true
            #Ensure = 'Absent'
        }

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

        NetDeploy ADDS
        {
            DeployId = $NetDeployID
            NdisDeviceType = '0'
        }

        ADObjectPermissionEntry RslDdp
        {
            Ensure                             = 'Present'
            Path                               = 'CN=ROLE01,CN=Computers,DC=contoso,DC=com'
            IdentityReference                  = 'CONTOSO\CLUSTER01$'
            ActiveDirectoryRights              = 'GenericAll'
            AccessControlType                  = 'Allow'
            ObjectType                         = '00000000-0000-0000-0000-000000000000'
            ActiveDirectorySecurityInheritance = 'None'
            InheritedObjectType                = '00000000-0000-0000-0000-000000000000'
        }

        # CN=SYSVOL Share,CN=Content,CN=Domain System Volume,CN=DFSR-GlobalSettings,CN=System,DC=SerraMedicalClinic,DC=net # msDFSR-DirectoryFilter

        # SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters\ set 'DisabledComponents' Dword dec 33, hex 21: prefer IPv4, disalbe tunnel-6.

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

        #ADDSOU $NodeName
        #{
        #    Get-ADUser -Identity "S-1-5-21-1656681450-3381289342-4079706298-502"
        #    
        #}

        ADGroup ESXAdmins
        { # idea: overload Hyper-V Administrators...?
            #BETTER IDEA: fSpecifyGUIDOnAdd heuristic is true in the dSHeuristics
            # https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-adts/e5899be4-862e-496f-9a38-33950617d2c5
            GroupName  = 'ESX Admins'
            DisplayName = "ESXi Administrators"
            Description = "Members have administrative privileges on VMware ESXi hosts joined to this domain."
            GroupScope = 'DomainLocal'
            RestoreFromRecycleBin = $true

            DependsOn = "[WaitForAny]PDCe"
        }

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

            DependsOn = "[WaitForADDomain]$NodeName"
        }

        ADReplicationSubnet Hamachi
        {
            Name        = '25.0.0.0/8'
            Site        = 'Hamachi'
            Location    = 'VPN'
            Description = 'LogMeIn Hamachi'

            DependsOn = "[ADReplicationSite]Hamachi"
        }

        Script ADReplicationHamachi
        {
            #don't display in general UI
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
                #$MyIP = $State.CurrentIP | select -ExpandProperty IPAddress
                $MyIP = Get-NetIPAddress -PrefixOrigin Manual -AddressFamily IPv4 -ErrorAction SilentlyContinue | select -ExpandProperty IPAddress -ErrorAction SilentlyContinue
                #$PublishedIP = $State.Result | select -ExpandProperty PublishAddresses
                $PublishedIP = Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\DNS\Parameters -Name PublishAddresses -ErrorAction SilentlyContinue | select -ExpandProperty PublishAddresses -ErrorAction SilentlyContinue

                #foreach ($IP in $State.CurrentIP)
                #{
                    #foreach ($PA in $State.Result.Split(" "))
                    #{}
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
                Restart-Service -Name DNS
                Register-DnsClient
            }

            DependsOn = "[Service]DNS"
        }

        ADReplicationSite $NodeName
        {
            RenameDefaultFirstSiteName = $true
            Name = $NodeName
            Description = $Node.Description

            DependsOn = "[WaitForADDomain]$NodeName"
        }

        foreach ($Site in $Node.Sites)
        {
            $SiteName = $Site.Name
<#
            foreach ($Subnet in $ConfigurationData.Subnets)
            {   $SubnetId = "10."+ $Site.SiteIndex +"."+ $Subnet.VLAN #+".0"

                xDHCPServerScope "$SiteName$($Subnet.Name)"
                {
                    Name = "VLAN"+ $Subnet.VLAN +" "+ $Subnet.Name
                    ScopeId = $SubnetId +".0"
                    SubnetMask = "255.255.255.0"
                    LeaseDuration = '08:00:00' #New-TimeSpan -Hours 8
                    AddressFamily = "IPv4"

                    IPStartRange = $SubnetId +".40"
                    IPEndRange = $SubnetId +".239"

                    DependsOn = "[Service]DHCP"
                }
                xDhcpServerExclusionRange "$SiteName$($Subnet.Name)Static"
                {
                    ScipeId = $SubnetId +".0"
                    AddressFamily = "IPv4"

                    IPStartRange = $SubnetId +".40"
                    IPEndRange = $SubnetId +".99"

                    DependsOn = "[xDHCPServerScope]$SiteName$($Subnet.Name)"
                }
                xDhcpServerExclusionRange $SiteName + $Subnet.Name + "Network"
                {
                    ScipeId = $SubnetId +".0"
                    AddressFamily = "IPv4"

                    IPStartRange = $SubnetId +".200"
                    IPEndRange = $SubnetId +".239"

                    DependsOn = "[xDHCPServerScope]$SiteName$($Subnet.Name)"
                }

                ADReplicationSubnet "$SiteName$($Subnet.Name)"
                {
                    Name = $SubnetId + ".0/24"
                    Site = $SiteName
                    Location = $Site.Location
                    Description = $Subnet.Description

                    DependsOn = "[ADReplicationSite]$SiteName"
                }
            }#>

            ADReplicationSite $SiteName
            {
                Name = $SiteName
                DependsOn = "[ADReplicationSite]$NodeName"
            }
        }#>

        ADReplicationSubnet $NodeName
        {
            Name = '10.'+($Node.ClientIndex)+'.32.0/20'
            Site = $NodeName
            Description = $Node.Description
            Location = $Node.Location

            DependsOn = "[ADReplicationSite]$NodeName"
        }

        DNSRecordCName $NodeName
        {
            Name = $NodeName
            ZoneName = $Node.DNSName
            HostNameAlias = $Node.DNSName

            DependsOn = "[WaitForADDomain]$NodeName"
        }

        WaitForADDomain $NodeName
        {
            DomainName              = $Node.DNSName
            #SiteName                = $NodeName
            WaitForValidCredentials = $true

            DependsOn = "[Service]NTDS","[Service]DNS"
        }

        WaitForAny PDCe
        {
            ResourceName = "[WaitForADDomain]$NodeName"
            NodeName = $Node.DNSName

            DependsOn = "[WaitForADDomain]$NodeName"
        }
<#
        Script WaitForPDCe
        {
            # figure out how to locate and force replication with PDCe?
            # Try to query PDCe if DSC has completed and *then* force replication?
            # Invoke-DscResource WaitForAny NodeName = $TehPDCe, ResourceName = "[everything]completed"?
            # DSC full success happened more recently than local configuration last modified?
        }
#>
        ADForestProperties $NodeName
        {
            ForestName                  = $Node.DNSName
            UserPrincipalNameSuffix     = $Node.ExternalDomains
            ServicePrincipalNameSuffix  = $Node.InternalDomains
            TombstoneLifetime           = 2401 # 6 and a half years

            DependsOn = "[WaitForADDomain]$NodeName"
        }
<#
        ADOptionalFeature $NodeName
        {
            FeatureName                       = "Recycle Bin Feature"
            EnterpriseAdministratorCredential = New-Object System.Management.Automation.PSCredential("NT Authority\SYSTEM", (new-object System.Security.SecureString))
            ForestFQDN                        = $Node.DNSName

            DependsOn = "[WaitForAny]PDCe","[ADForestFunctionalLevel]$NodeName"
        }
#>
<#
        ADForestFunctionalLevel $NodeName
        {
            ForestIdentity = $Node.DNSName
            ForestMode     = 'Windows2008R2Forest' #Windows2008R2Forest, Windows2012Forest, Windows2012R2Forest, Windows2016Forest

            DependsOn = "[WaitForAny]PDCe"
        }

        ADDomainFunctionalLevel $NodeName
        {
            DomainIdentity = $Node.DNSName
            DomainMode     = 'Windows2008R2Domain' #Windows2008R2Domain, Windows2012Domain, Windows2012R2Domain, Windows2016Domain

            DependsOn = "[WaitForAny]PDCe"
        }
#>
        ADOrganizationalUnit $NodeName
        {
            Name                            = $NodeName
            Path                            = $NodeDistinguishedName
            Description                     = $Node.Description
            ProtectedFromAccidentalDeletion = $true
            RestoreFromRecycleBin           = $true

            DependsOn = "[WaitForADDomain]$NodeName"
        }

        if($Node.DomainSid)
        {
            Group Administrators
            {
                GroupName = 'S-1-5-32-544'
                MembersToInclude= 'S-1-5-9'
                #Members= "$($Node.DomainSid)-$ridDA", "$($Node.DomainSid)-$ridEA", "$ERWDC"
                #$ERWDC = [System.Security.Principal.SecurityIdentifier]'S-1-5-9'

                DependsOn = "[WaitForADDomain]$NodeName" #,"[WindowsFeature]ADDSt"
        }   }

        ADManagedServiceAccount AGPM
        {
            ServiceAccountName = 'AGPM'
            AccountType = 'Group'
            DisplayName = 'Advanced Group Policy Management'
            #Description = ""

            DependsOn = "[ADKDSKey]KDS","[WaitForAny]PDCe"
        }

        #Group AGPM
        #{
        #    GroupName= (Join-Path $NodeName "Group Policy Creator Owners")
        #    MembersToInclude = (Join-Path $NodeName 'AGPM$')

        #    DependsOn = "[ADManagedServiceAccount]AGPM"
        #}

        ADManagedServiceAccount AADC
        {
            ServiceAccountName = 'AADC'
            AccountType = 'Group'
            DisplayName = 'Azure Active Directory Connect'
            #Description = ""

            #ManagedPasswordPrincipals = 'S-1-5-9'

            DependsOn = "[ADKDSKey]KDS","[WaitForAny]PDCe"
        }

        xDnsServerConditionalForwarder IT
        {
            Name = "Mayflower.IT"
            MasterServers = "25.19.19.115","25.17.102.96"
            ReplicationScope = "Forest"

            DependsOn = "[WaitForADDomain]$NodeName","[WindowsFeature]DNSt"
        }
        xDnsServerConditionalForwarder TI
        {
            Name = '25.in-addr.arpa'
            MasterServers = "25.19.19.115","25.17.102.96"
            ReplicationScope = "Forest"

            DependsOn = "[WaitForADDomain]$NodeName","[WindowsFeature]DNSt"
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
            Name             = ''+($Node.ClientIndex)+'.10.in-addr.arpa'
            DynamicUpdate    = 'Secure'
            ReplicationScope = 'Forest'
            Ensure           = 'Present'

            DependsOn = "[WaitForADDomain]$NodeName","[WindowsFeature]DNSt"
        }
        xDnsServerADZone xARPA
        {
            Name             = '.10.in-addr.arpa'
            DynamicUpdate    = 'Secure'
            ReplicationScope = 'Forest'
            Ensure           = 'Absent'

            DependsOn = "[WaitForADDomain]$NodeName","[WindowsFeature]DNSt"
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

            DependsOn = "[WindowsFeature]ADDS" # how to make this only go if DCPROMO is completed?
        }

        ADKDSKey KDS
        {
            Ensure = "Present"
            EffectiveTime = '5/1/2018 00:00'
            AllowUnsafeEffectiveTime = $true

            DependsOn = "[WaitForADDomain]$NodeName","[WindowsFeature]ADDSt"
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
            Name   = "RSAT-DNS-Server"
            Ensure = 'Present'
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

        OMSagent OMSnode
        {
            OPSINSIGHTS_PID    = $OPSINSIGHTS_PID
            OPSINSIGHTS_WS_ID  = $OPSINSIGHTS_WS_ID
            OPSINSIGHTS_WS_KEY = $OPSINSIGHTS_WS_KEY
        }

    }#$AllNodes

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
    Update-Module -Scope AllUsers -Name Az
	Connect-AzAccount
	$MySubscription = "c42f346f-e80f-48e5-ad8e-30a25c669714" # Assigned Partner Benefit
	Set-AzContext -Subscription $MySubscription
	$MyResourceGroup = 'Kalimdor'
	$MyAutomationAccount = 'Drustvar'
	
    if($PSCommandPath)
    {
        $MySourcePath = $PSCommandPath
        $MyPrivateData = Join-Path $PSScriptRoot "PrivateData"
    }
    else
    {
        $MySourcePath = "declare-gWDSC.ps1"
        $MyPrivateData = Resolve-Path "PrivateData"
    }

	Import-AzAutomationDscConfiguration -SourcePath $MySourcePath -ResourceGroupName $MyResourceGroup -AutomationAccountName $MyAutomationAccount

    $gWdsc = Import-PowerShellDataFile -Path (Join-Path $MyPrivateData "gWadds.psd1")
	Start-AzAutomationDscCompilationJob -ResourceGroupName $MyResourceGroup -AutomationAccountName $MyAutomationAccount -ConfigurationName 'gW' -ConfigurationData $gWdsc
	#Import-AzAutomationDscNodeConfiguration -AutomationAccountName $MyAutomationAccount -ResourceGroupName $MyResourceGroup -ConfigurationName 'gW' -Path 'C:\MyConfigurations\TestVM1.mof'
}

#https://docs.microsoft.com/en-us/azure/automation/automation-dsc-compile#manage-configurationdata-when-compiling-configurations-in-azure-automation
# https://docs.microsoft.com/en-us/powershell/scripting/windows-powershell/wmf/whats-new/dsc-improvements?view=powershell-7.1#dsc-module-and-configuration-signing-validations
# https://devblogs.microsoft.com/powershell/separating-what-from-where-in-powershell-dsc/
# https://docs.microsoft.com/en-us/azure/automation/compose-configurationwithcompositeresources#compose-a-configuration
# https://docs.microsoft.com/en-us/powershell/scripting/dsc/tutorials/bootstrapdsc?view=powershell-5.1
# https://docs.microsoft.com/en-us/azure/automation/shared-resources/modules#internal-cmdlets
# 
