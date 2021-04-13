
@{

    # Script module or binary module file associated with this manifest.
    # RootModule = ''
    
    # Version number of this module.
    ModuleVersion = '0.5.8'
    
    # ID used to uniquely identify this module
    GUID = '7f189a65-2fc1-4970-b864-266b8aadff29'
    
    # Author of this module
    Author = 'John D Pell'
    
    # Company or vendor of this module
    CompanyName = 'Mayflower IS&T'
    
    # Copyright statement for this module
    Copyright = '(c) 2020 gaelicWizard.LLC. All rights reserved.'
    
    # Description of the functionality provided by this module
    # Description = ''
    
    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'
    
    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = 'Amd64'
    
    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()
    
    # Assemblies that must be loaded prior to importing this module
    # RequiredAssemblies = @()
    
    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    ScriptsToProcess = @('Update-PowerShellPackageManagement.ps1','Install-MSO365.ps1') #,'Enable-WindowsRSAT.ps1')
    
    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()
    
    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()
    
    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules = @('MayflowerAPI') #,'MayflowerSync')
    
    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @()
    
    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport = @()
    
    # Variables to export from this module
    VariablesToExport = '' #'*'
    
    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport = @()
    
    # DSC resources to export from this module
    DscResourcesToExport = @('OMSagent','NetDeploy')
    
    # List of all modules packaged with this module
    # ModuleList = @()
    
    # List of all files packaged with this module
    # FileList = @('ConfigureSCP.ps1')
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData = @{
    
        PSData = @{
    
            # Tags applied to this module. These help with module discovery in online galleries.
            # Tags = @()
    
            # A URL to the license for this module.
            # LicenseUri = ''
    
            # A URL to the main website for this project.
            # ProjectUri = ''
    
            # A URL to an icon representing this module.
            # IconUri = ''
    
            # ReleaseNotes of this module
            # ReleaseNotes = ''
    
        } # End of PSData hashtable
    
    } # End of PrivateData hashtable
    
    # HelpInfo URI of this module
    # HelpInfoURI = ''
    
    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
    
    }
    