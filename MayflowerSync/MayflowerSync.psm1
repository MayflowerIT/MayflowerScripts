###
## Initialize the Mayflower Sync service
###
## This script sets up the Mayflower Sync service (Resilio Sync in "config mode").
##TODO:
# - utilities functions (for other scripts to add folders to Sync)
# - .sync\IgnoreList
##
#requires -Version 5.1
#requires -Modules PoshPrivilege,Hyper-V,MayflowerAPI
#requires -RunAsAdministrator #Requires -Version 4


#Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Tools-All

## Constants for sync service
New-Variable -Option Constant -Name Service_Name           -Value "Mayflower Sync"
New-Variable -Option Constant -Name ServiceName            -Value ($Service_Name -replace ' ','')
New-Variable -Option Constant -Name svcnm                  -Value ($ServiceName -replace '[aeiou]','')

New-Variable -Option Constant -Name syncbinpath            -value "System\${ServiceName}_x64.exe"

New-Variable -Option Constant -Name storagePath            -Value "$env:ProgramData\${ServiceName}"
New-Variable -Option Constant -Name configFile             -Value "$storagePath\$($ServiceName).json"
New-Variable -Option Constant -Name directoryRoot          -Value "$env:SystemDrive\Sync"
New-Variable -Option ReadOnly -Name SWsetup                -Value "$env:SystemDrive\SWSetup"

# Constants for security principals
New-Variable -Option Constant -Name authenticatedUsers     -Value "NT Authority\Authenticated Users"
New-Variable -Option Constant -Name svcAccount             -Value "NT Service\$svcnm"
#New-Variable -Option Constant -Name svcPrincipal           -Value (New-Object System.Security.Principal.Ntaccount($svcAccount)) # Using the SID allows for definition without the service existing first
New-Variable -Option Constant -Name svcPrincipal           -Value (New-Object System.Security.Principal.SecurityIdentifier("S-1-5-80-3205537406-4137754249-169882727-3179488493-1634019866") )
New-Variable -Option Constant -Name enterpriseAdminsIT     -Value (New-Object System.Security.Principal.SecurityIdentifier("S-1-5-21-823138865-2180804847-3056398356-519") )
New-Variable -Option Constant -Name ntSystem               -Value (New-Object System.Security.Principal.SecurityIdentifier("S-1-5-18") )

# download path
#New-Variable -Option Constant -Name resilioURI             -Value "https://download-cdn.resilio.com/stable/windows64/Resilio-Sync_x64.exe"
New-Variable -Option Constant -Name resilioURI             -Value "https://download-cdn.getsync.com/2.6.4/windows64/Resilio-Sync_x64.exe"

# Constants for policy objects
New-Variable -Option Constant -Name DDP                    -Value "{31B2F340-016D-11D2-945F-00C04FB984F9}"
New-Variable -Option Constant -Name DDCP                   -Value "{6AC1786C-016F-11D2-945F-00C04FB984F9}"
# invocation variables
New-Variable -Option ReadOnly -Name thisComputer           -Value (gwmi -Class Win32_ComputerSystem -ErrorAction Stop)
New-Variable -Option ReadOnly -Name thisWindows            -Value (gwmi -Class Win32_OperatingSystem -ErrorAction Stop)
New-Variable -Option ReadOnly -Name hyperV                 -Value (get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V)
if ($hyperV.state -eq 'Enabled')
{
    New-Variable -Option ReadOnly -Name hyperVHDs          -Value (get-VMHost).VirtualHardDiskPath
    New-Variable -Option ReadOnly -Name hyperVroot         -Value (Resolve-Path -Path "$hyperVHDs\..")
}
New-Variable -Option ReadOnly -Name SysvolReady            -Value (Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters -Name SysvolReady -ErrorAction SilentlyContinue | select -ExpandProperty SysVolReady)
if ($sysvolReady)
{
    New-Variable -Option ReadOnly -Name sysvol             -Value (Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters -Name Sysvol -ErrorAction STOP | select -ExpandProperty SysVol)
    New-Variable -Option ReadOnly -Name sysvolPath         -Value (Resolve-Path -Path "$sysvol\..\domain" -ErrorAction STOP)
    New-Variable -Option ReadOnly -Name sysvolPolicies     -Value (Resolve-Path -Path "$sysvolPath\Policies" -ErrorAction STOP)
    New-Variable -Option ReadOnly -Name sysvolScripts      -Value (Resolve-Path -Path "$sysvolPath\Scripts" -ErrorAction STOP)
}

# Access Rules to add to ACLs
New-Variable -Option Constant -Name allowSyncFullControl   -Value ( New-Object System.Security.AccessControl.FileSystemAccessRule($svcPrincipal,"FullControl","ContainerInherit,ObjectInherit","None","Allow") )
New-Variable -Option Constant -Name allowAdminsFullControl -Value ( New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Administrators","FullControl","ContainerInherit,ObjectInherit","None","Allow") )
New-Variable -Option Constant -Name allowAdminsReadExecute -Value ( New-Object System.Security.AccessControl.FileSystemAccessRule("BUILTIN\Administrators","ReadAndExecute","ContainerInherit,ObjectInherit","None","Allow") )
New-Variable -Option Constant -Name allowAllReadExecute    -Value ( New-Object System.Security.AccessControl.FileSystemAccessRule($authenticatedUsers,"ReadAndExecute","ContainerInherit,ObjectInherit","None","Allow") )
#New-Variable -Option Constant -Name allowDFSRFullControl   -Value ( New-Object System.Security.AccessControl.FileSystemAccessRule("NT Service\DFSR","FullControl","ContainerInherit,ObjectInherit","None","Allow") )
New-Variable -Option Constant -Name allowSYSTEMFullControl -Value ( New-Object System.Security.AccessControl.FileSystemAccessRule($ntSystem,"FullControl","ContainerInherit,ObjectInherit","None","Allow") )

# Access Control Lists
New-Variable -Option Constant -Name emptyACL -Value (New-Object System.Security.AccessControl.DirectorySecurity) 
    # entirely blank Access Control List; used for resetting inherited permissions

$syncFolderACL = New-Object System.Security.AccessControl.DirectorySecurity # start with entirely blank Access Control List
$syncFolderACL.SetOwner($svcPrincipal)
$syncFolderACL.SetGroup($ntSystem)
$syncFolderACL.SetAccessRule($allowSyncFullControl)
$syncFolderACL.SetAccessRule($allowSYSTEMFullControl) # don't be clever
$syncFolderACL.SetAccessRule($allowAdminsReadExecute) # Admins are the users here, so apply this to admins too
$syncFolderACL.SetAccessRule($allowAllReadExecute)
$syncFolderACL.SetAccessRuleProtection($true,$false) # disable inheritance without converting inherited rules
Set-Variable -Name syncFolderACL -Option ReadOnly
    # Access Control List for each sync folder

$dotSyncACL = New-Object System.Security.AccessControl.DirectorySecurity # start with entirely blank Access Control List
$dotSyncACL.SetOwner($svcPrincipal)
$dotSyncACL.SetGroup($ntSystem)
$dotSyncACL.SetAccessRule($allowSyncFullControl)
$dotSyncACL.SetAccessRule($allowSYSTEMFullControl) # don't be clever
$dotSyncACL.SetAccessRule($allowAdminsFullControl) # don't be clever
$dotSyncACL.SetAccessRuleProtection($true,$false) # disable inheritance without converting inherited rules
Set-Variable -Name dotSyncACL -Option ReadOnly
    # Access Control List for the '.sync' hidden folder in each sync folder

$storageACL = New-Object System.Security.AccessControl.DirectorySecurity # start with entirely blank Access Control List
$storageACL.SetOwner($svcPrincipal)
$storageACL.SetGroup($ntSystem)
$storageACL.SetAccessRule($allowSyncFullControl)
$storageACL.SetAccessRule($allowSYSTEMFullControl) # don't be clever
$storageACL.SetAccessRule($allowAdminsFullControl) # don't be clever
$storageACL.SetAccessRule($allowAllReadExecute) # don't block UAC; nothing secret here
$storageACL.SetAccessRuleProtection($true,$false) # disable inheritance without converting inherited rules
Set-Variable -Name storageACL -Option ReadOnly
    # Access Control List for the ProgramData folder for the sync service



$defaultSyncConfig = @{
    device_name = $ENV:ComputerName # good
    listening_port = 3839 # good
    storage_path = $storagePath # good
    use_upnp = $true # good
    download_limit = 0 # good
    upload_limit = 0 # good

    send_statistics = $true # good
    peer_expiration_days = 49 # good
    free_space_warning_threshold = 8192 # good
    log_ttl = 49 # good
    disk_low_priority = $true # good
    use_advapi_crypto = $true # good
#    net_enable_utp2 = $true
    folder_rescan_interval = 28800 # good
    sync_max_time_diff = 1200 # good
    sync_trash_ttl = 49 # good
    lan_encrypt_data = $true # good
    ignore_symlinks = $true # good
#    "folder_defaults.use_tracker" = $true # good
#    "folder_defaults.use_lan_boradcast" = $true
#    "folder_defaults.use_relay" = $true # good
    "folder_defaults.delete_unknown_files" = $true # good
    "folder_defaults.known_hosts" = "Sync.MayflowerInfotech.com:3389" # good
    overwrite_changes = $true # good
    lazy_indexing = $true # good
    direct_torrent_enabled = $true # good
    sync_extended_attributes = $false # good
#    disk_min_free_space = "10"
#    disk_min_free_space_gb = "10" # good
    enable_file_system_notifications = $true # good
    shared_folders = @() 
}



function Initialize-MayflowerSync
{   [CmdletBinding()]
     #SupportsShouldProcess=$True ShouldContinue
    param(
        [Parameter(Mandatory=$false)]
            [PSDefaultValue(Help = '$false')]
            [switch]$AllowClobber = $false, #rename to force?
        [Parameter(Mandatory=$false,
            ValueFromPipeline=$true)]
            [String[]]$ComputerName
    )

    Begin
    {
        if (($thisWindows.OSArchitecture -notlike "64-bit") -or ($PSVersionTable.PSVersion.Major -lt 3) )
        {throw "Mayflower Sync requires 64-bit Windows with PowerShell 3 or greater."}
        #-or (gwmi win32_product -Filter "name like '%Exchange%'") 
        
        if (Test-Path $configFile -PathType Leaf) #more checks
        {
            throw "A Mayflower Sync configuration file already exists."
        }
        
        Stop-Service -name $svcnm -Force -ErrorAction SilentlyContinue
    }

    Process
    {
        Install-MayflowerSync
        
        
        md $storagePath -errorAction SilentlyContinue # create if not exist
        Test-Path -Path $storagePath -PathType Container -ErrorAction STOP # do error if it doesn't exist
        Set-Acl -Path $storagePath -AclObject $storageACL -ErrorAction STOP
        
        $defaultSyncConfig | Write-MayflowerSyncConfig #-Confirm:!$allowClobber
    }


    End
    {
        md $directoryRoot -ErrorAction SilentlyContinue # don't error if it already exists
        Test-Path -Path $directoryRoot -PathType Container -ErrorAction STOP # do error if it doesn't exist
        $directoryACL = Get-Acl $directoryRoot -ErrorAction Stop # preserve any existing special permissions
        $directoryACL.SetOwner($svcPrincipal)
        $directoryACL.SetGroup($ntSystem)
        $directoryACL.SetAccessRule($allowSyncFullControl)
        $directoryACL.SetAccessRule($allowSYSTEMFullControl) # don't be clever
        $directoryACL.SetAccessRule($allowAdminsFullControl) # don't be clever
        $directoryACL.SetAccessRule($allowAllReadExecute)
        $directoryACL.SetAccessRuleProtection($true,$false) # (block inheritance?, retain inherited permissions?)
        Set-Acl -Path $directoryRoot -AclObject $directoryACL -ErrorAction STOP
    }
}

function Install-MayflowerSync
{
    [alias("Update-MayflowerSync")]
    [CmdletBinding()]
    Param()

    Begin
    {
        Stop-Service -name $svcnm -Force -ErrorAction SilentlyContinue

        #TODO: this doesn't belong here...but needed for invoke-webRequest to work properly...
        # set strong cryptography for .Net Framework (version 4 and above)
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord 
        Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
    }

    Process
    {
        Invoke-WebRequest -URI $resilioURI -OutFile "$env:SystemRoot\$syncbinpath" -ErrorAction STOP
            #TODO: wrap in job and start first
    }
    
    End
    {
        New-Service -Name $svcnm -BinaryPathName "`"%SystemRoot%\$syncbinpath`" /SVC -n $($svcnm) /storage `"%ProgramData%\${ServiceName}`" /config `"%ProgramData%\${ServiceName}\${ServiceName}.json`"" -DisplayName "${Service_Name}" -StartupType Disabled -ErrorAction SilentlyContinue
        $service = gwmi win32_service -filter "name='$($svcnm)'" -ErrorAction Stop
        $service.change($null,$null,$null,$null,$null,$null,$svcAccount,$null)
    }
}

function Write-MayflowerSyncConfig
{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true)]
            [System.Object]$syncConfig
    )
#TODO: add switch to restart service
    Write-Verbose "Writing MayflowerSync.json configuration file."
    Write-Debug "Writing MayflowerSync.json: $syncConfig."
    $syncConfig | ConvertTo-JSON -Depth 4 -ErrorAction STOP | Out-File -Encoding ascii -filePath $configFile -Force -ErrorAction STOP
}

function configure-MayflowerSync
{   [CmdletBinding()]
    Param()

Begin{
    if (($thisWindows.ProductType -eq 2) -and ($sysvolReady) -and ($sysvolPath))
    { # Domain Controller
        $myflwrScripts      = $sysvolScripts
        $policyDefinitions  = "$sysvolPolicies\PolicyDefinitions"
        $baseline           = "$sysvolPolicies\$DDP"
        $controllers        = "$sysvolPolicies\$DDCP"
    } else { # Domain Member
        $myflwrScripts      = "$directoryRoot\MayflowerScripts"
        $policyDefinitions  = "$directoryRoot\PolicyDefinitions"
        $baseline           = "$directoryRoot\Baseline"
        $controllers        = "$directoryRoot\Standard"
    }
}
Process{
    if (($thisWindows.ProductType -eq 2) -or (($thisWindows.ProductType -eq 3) -and ($thisComputer.model -notlike '*irtual*')))
    { # DC or physical host
        Add-MayflowerSyncFolder -secret "ET3ASDH5EJF3K2U6QXFRD5B6DEVPEDVSJIO3DUVQOTD76MLFU3UYKKQNN4E" -Path $baseline
        Add-MayflowerSyncFolder -secret "EVPHGXTAOVM5CIZKTWQZXKM3OD53V7PYKW6GNUIL3WZZZ5LQO7QO73NJSBU" -Path $myflwrScripts
        Add-MayflowerSyncFolder -secret "E6ATNTFAO2AJ56IUVWQWB76WRFJ45SLSE27OAIFZRWATSWNAA33FNNIAOHM" -Path $policyDefinitions
        Add-MayflowerSyncFolder -secret "EC3M3XXDUF3QL5Y7EGZ2ZYETIY53DUW2XE5EF5GKXMYCHMUCXRCYI6XAJEA" -Path $controllers
    }
    
    
    if(($false) -and ($thisComputer.model -notlike '*irtual*'))
    { # Any physical host
        Add-MayflowerSyncFolder -secret "E776EKMNRKSFJXFIF7TWJ3CGJAVUB4NSCMIL6QCOR6KXTF2GNFCIATR2QNM" -Path $SWSetup
    }
    
    ## Assume that a physical computer running Hyper-V is a virtualization host and should sync large ISOs locally
    if (($hyperV.state -eq 'Enabled') -and ($thisComputer.model -notlike '*irtual*'))
    {   # THIS FOLDER IS LARGE
        $HyperISOs  = "$hyperVroot\ISOs"
        $HyperMetal = "$hyperVroot\Bare Metal"
    
        Add-MayflowerSyncFolder -secret "ERP72SLQGRKBSXICB62VEZWZYOAYZ4QYJHMKLKC6FNDHZMRB57J5BGLXATY" -Path $HyperISOs
        #Add-MayflowerSyncFolder -secret "EOZARBJ6AVPFNKPKDBAWEYCBQKV3Q65FKWPSJG3IWI3JV7PUUH4M6F4V7UY" -Path $HyperMetal
    }
}
End{
    if((get-MayflowerSyncFolder).Count -gt 0)
    {
        Set-Service -Name $svcnm -StartupType Automatic -ErrorAction Stop
        Start-Service -Name $svcnm -Confirm
    }
}
}


function get-MayflowerSyncConfig
{   [CmdletBinding()]
    Param()
    if (Test-Path $configFile -PathType Leaf)
    {
        gc $configFile -ErrorAction STOP | ConvertFrom-Json -ErrorAction STOP
    }
}

function get-MayflowerSyncFolder
{   [CmdletBinding()]
    Param()
    $syncConfig = get-MayflowerSyncConfig
    if ($syncConfig)
    {
        $syncConfig.shared_folders
    }
}


function add-MayflowerSyncFolder
{   [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
            [String]$secret,
        [Parameter(Mandatory=$true)]
            [String]$Path
    )
    
    Begin 
    {
        $moar_folders = New-Object System.Collections.ArrayList($null)
        if (Test-Path $configFile)
        {
            $syncConfig = get-MayflowerSyncConfig
            Write-Verbose "Getting existing MayflowreSync folders."
            if ($syncConfig.shared_folders)
            {
                #Write-Debug "Adding range"
                #$moar_folders.AddRange($syncConfig.shared_folders) # read existing folders
            }
            # THIS NEEDS A MECHANISM TO UNIQUE THE OUTPUT
            if($moar_folders.Count -gt 0)
            { # If there are existing folders
                Write-Debug "Iterating over existing MayflowreSync folders."
                foreach($syncd in $moar_folders)
                { # Add Persephone to all folders known_hosts
                    Write-Debug "$syncd"
                    $syncd.known_hosts = "Sync.MayflowerInfotech.com:3389"
                }
            }
        }
        else { throw "Mayflower Sync has not been initialized." }

        $setAclJobs = New-Object System.Collections.ArrayList($null)
    }
    Process
    {
        #check if folder already being sync'd
        #add folder to config
        $add_folder = @{
            dir = $Path
            secret = $secret
        }
        #TODO: iterate if $secret is already present
        if (!$isAlreadyThere)
        {
            Write-Verbose "Adding $Path to MayflowerSync.json."
            $moar_folders += $add_folder

            Resolve-Path "$Path\.." -ErrorAction STOP
            md $Path -ErrorAction SilentlyContinue
            md "$Path\.sync" -ErrorAction SilentlyContinue

            Write-Verbose "Setting ACLs on $Path."
            #$setAclJobs += Start-Job -Name "Set ACLs on $Path" -ScriptBlock `
            #{
            #    Import-Module (Split-Path -Parent $MyInvocation.MyCommand.Definition)
            #    $using:Path | set-MayflowerSyncACL
                $Path | set-MayflowerSyncACL
            #}
        }
        #Write-Debug $moar_folders
        $syncConfig.shared_folders += $moar_folders
        #Write-Debug $syncConfig.shared_folders
    }
    End
    {
        #Write new config
        #$syncConfig.shared_folders = $moar_folders
        Write-Debug "Saving shared folders: $($syncConfig.shared_folders|ConvertTo-Json -Depth 4)"
        Write-MayflowerSyncConfig -syncConfig $syncConfig
        $setAclJobs | Wait-Job | Receive-Job
        #Restart-Service -Name $svcnm -Verbose
    }
}

function set-MayflowerSyncACL
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
            [PSDefaultValue(Help = '$false')]
            [switch]$SkipConfigCheck = $false, #rename to force?
        [Parameter(Mandatory=$true,
            ValueFromPipeline=$true)]
            [string]$Path,
        [Parameter(Mandatory=$false)]
            [System.Security.AccessControl.DirectorySecurity]$AclObject
    )

    Begin
    {
        #verify Initialize has been called already
        if ((!$skipConfigCheck) -and (!(Test-Path $configFile)))
        {throw "You must call Initialize-MayflowerSync first."}
        #validate arguments: (1) folder is in config already? (2) ACL procided is an ACL object? (3) ACL globals exist?
        # enable Restore privilege
        #re-write directory root ACL on each run?

        $clearAclJobs = New-Object System.Collections.ArrayList($null)


        ###
        Write-Verbose "Enabling the Restore privilege."
        Enable-Privilege -Privilege SeRestorePrivilege
        ###
    }
    Process
    {
        $place = $Path

        Set-Acl -Path "$place\.sync" -AclObject $dotSyncACL -ErrorAction STOP
        Set-Acl -Path $place -AclObject $syncFolderACL -ErrorAction STOP

        $clearAclJobs += Start-Job -Name "Clear-ACLs from children of $place" -ScriptBlock {
#            Write-Verbose $(get-privilege -CurrentUser)
            ls -Path $using:place -Recurse -Attributes !ReparsePoint -Exclude .sync | Set-Acl -AclObject $using:emptyACL
        }
    }
    End
    {
        $clearAclJobs | Wait-Job | Receive-Job

        if (!$restorePrivilegeWasAlreadyEnabled)
        {
            Write-Verbose "Disabling the Restore privilege."
            Disable-Privilege -Privilege SeRestorePrivilege
        }
    }
}
