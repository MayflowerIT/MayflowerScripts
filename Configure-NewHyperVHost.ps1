<#

  ConfigureBinoviaVMHostWithSAN.ps1

 https://blogs.technet.microsoft.com/heyscriptingguy/2013/10/08/using-powershell-to-set-up-hyper-v/

 https://blogs.technet.microsoft.com/virtualization/2012/08/16/introduction-to-resource-metering/ 

 https://www.youtube.com/watch?v=SG3CfX52OSI
 
 https://www.youtube.com/watch?v=ed7HThAvp7o
#>
Import-Module -Name Hyper-V

Get-NetAdapter "Ethernet" | Rename-NetAdapter -NewName "Ethernet 1"

New-NetLBFOTeam -name "Riser" -TeamMembers "Ether*" -TeamingMode LACP -LoadBalancingAlgorithm Dynamic -Confirm:$true

New-NetLBFOTeam -name "Embedded" -TeamMembers "Embedded*" -TeamingMode LACP -LoadBalancingAlgorithm Dynamic -Confirm:$true
#Get-NetAdapterAdvancedProperty -Name "Embedded*" -DisplayName "Jumbo Packet" | Set-NetAdapterAdvancedProperty -RegistryValue "9014"

<# my systems can't do SR-IOV I think... #>

New-VMSwitch "Traffic" -NetAdapterName "Riser" -AllowManagement $false
New-VMSwitch "Core" -NetAdapterName "Embedded" -AllowManagement $true

Add-VMNetworkAdapter -ManagementOS -name "Management" -SwitchName "Core"
Set-VMNetworkAdapter -ManagementOS -name "Management" -MinimumBandwidthWeight 10 
Get-VMNetworkAdapter -ManagementOS -name "Management" | Set-VMNetworkAdapterVlan -Access -VlanId 100

Add-VMNetworkAdapter -ManagementOS -name "Drobo SAN" -SwitchName "Core"
Set-VMNetworkAdapter -ManagementOS -name "Drobo SAN" -MinimumBandwidthWeight 40
Get-VMNetworkAdapter -ManagementOS -name "Drobo SAN" | Set-VMNetworkAdapterVlan  -Access -VlanId 2

Add-VMNetworkAdapter -ManagementOS -name "Migration" -SwitchName "Core"
Set-VMNetworkAdapter -ManagementOS -name "Migration" -MinimumBandwidthWeight 40
Get-VMNetworkAdapter -ManagementOS -name "Migration" | Set-VMNetworkAdapterVlan  -Access -VlanId 101

Add-VMNetworkAdapter -ManagementOS -name "Cluster" -SwitchName "Core"
Set-VMNetworkAdapter -ManagementOS -name "Cluster" -MinimumBandwidthWeight 10
Get-VMNetworkAdapter -ManagementOS -name "Cluster" | Set-VMNetworkAdapterVlan  -Access -VlanId 102

Add-VMNetworkAdapter -ManagementOS -name "Legacy" -SwitchName "Traffic"
Set-VMNetworkAdapter -ManagementOS -name "Legacy" -MinimumBandwidthWeight 10
Get-VMNetworkAdapter -ManagementOS -name "Legacy" | Set-VMNetworkAdapterVlan  -Access -VlanId 1
#Disable-NetAdaper "Legacy"

Add-VMNetworkAdapter -ManagementOS -name "Production" -SwitchName "Traffic"
Set-VMNetworkAdapter -ManagementOS -name "Production" -MinimumBandwidthWeight 10
Get-VMNetworkAdapter -ManagementOS -name "Production" | Set-VMNetworkAdapterVlan  -Access -VlanId 903
#Disable-NetAdaper "Production"

#Add-NetLbfoTeamNIC -Team "Embedded" -Name "Management" -VlanID 100
#Add-NetLbfoTeamNIC -Team "Embedded" -Name "Drobo SAN" -VlanID 2
#Add-NetLbfoTeamNIC -Team "Embedded" -Name "Migration" -VlanID 101
#Add-NetLbfoTeamNIC -Team "Embedded" -Name "Cluster" -VlanID 102


#Set-VMMigrationNetwork 10.200.101.* 10.200.101.11



#New-NetAdapterAdvancedProperty -Name "Embedded" -RegistryDataType REG_DWORD -RegistryKeyword "IPAutoconfigurationEnabled" -RegistryValue "1"
$APIPAkey = "HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP\Parameters"
$APIPAvalue = "IPAutoconfigurationEnabled"
$APIPAdisabled = "0"
New-ItemProperty -Path $APIPAkey -Name $APIPAvalue -PropertyType DWORD -Value $APIPAdisabled -Force

Set-VMHost -MaximumVirtualMachineMigrations 2 –MaximumStorageMigrations 4 -VirtualMachineMigrationPerformanceOptions SMB
#Set-VMHost –UseAnyNetworkForMigration $true 
Set-VMHost –VirtualMachineMigrationAuthenticationType Kerberos
Set-VMHost -ResourceMeteringSaveInterval (New-TimeSpan -hours 1 -Minutes 30)

Set-Service -Name msiscsi -StartupType Automatic
Start-Service msiscsi
#Get-NetFirewallServiceFilter -Service msiscsi | Get-NetFirewallRule | Select DisplayGroup,DisplayName,Enabled
#Let GPO manage the firewall...
New-iSCSITargetPortal –TargetPortalAddress DeepSpace
Get-iSCSITarget
#Get-IscsiTarget | Connect-IscsiTarget

Enable-WindowsOptionalFeature -Online -FeatureName MultipathIO
Enable-MSDSMAutomaticClaim -BusType iSCSI # Auto claim iSCSI by MPIO
Set-MSDSMGlobalDefaultLoadBalancePolicy -Policy RR # Round Robin

# use "multiple connections per session" MCS instead of MPIO (can't do both)

#Get-IscsiTarget | Connect-IscsiTarget  -IsPersistent $True –IsMultipathEnabled $True –InitiatorPortalAddress $Nic1.IPAddress
#Get-IscsiTarget | Connect-IscsiTarget  -IsPersistent $True –IsMultipathEnabled $True –InitiatorPortalAddress $Nic2.IPAddress

#New-IscsiTargetPortal -TargetPortalAddress '169.254.6.0' -InitiatorPortalAddress '169.254.99.1' -AuthenticationType 'ONEWAYCHAP' -ChapSecret '93tR$f6AvVBPbG_7'
# quorum/witness: iqn.2005-06.com.drobo:b1200i.drb141101000087.id12
# data (new): id11
# data (old): id10





$VMDrive = “D:”

$VMPath = Join-Path -path $VMDrive -ChildPath “Hyper-V\VMs”
$VHDPath = Join-Path -Path $VMDrive -ChildPath “Hyper-V\VHDs”

MD -Path $vmpath,$VHDPath -ErrorAction 0

Set-VMHost -VirtualHardDiskPath $VHDPath -VirtualMachinePath $VMPath 

Set-VMReplicationServer -ReplicationEnabled $true -AllowedAuthenticationType Kerberos -ReplicationAllowedFromAnyServer $true -DefaultStorageLocation (Join-Path -Path $VMDrive -ChildPath "Hyper-V\Replicas")

