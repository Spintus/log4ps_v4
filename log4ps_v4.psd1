#
# Module manifest for module 'log4ps_v4'
#
# Generated by: Will Marcum
#
# Generated on: 8/10/2021
#

@{

    # Script module or binary module file associated with this manifest.
    RootModule         = 'log4ps_v4.psm1'

    # Version number of this module.
    ModuleVersion      = '4.0'

    # Supported PSEditions
    # CompatiblePSEditions = @()

    # ID used to uniquely identify this module
    GUID               = '9cbba2f9-8bc7-49e0-b1f7-3bf2a9c80787'

    # Author of this module
    Author             = 'Will Marcum'

    # Company or vendor of this module
    CompanyName        = 'Boulder Imaging'

    # Copyright statement for this module
    Copyright          = '(c) 2021 Will Marcum. All rights reserved.'

    # Description of the functionality provided by this module
    Description        = 'Wraps log4net dll for use with Powershell.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion  = '5.1'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    # Minimum version of the Windows PowerShell host required by this module
    # PowerShellHostVersion = ''

    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    # DotNetFrameworkVersion = '4.6.2'

    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    CLRVersion         = '4.0.30319'

    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''

    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @('lib\Powershell\Aliases')

    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies = 'lib\log4net-1.2.13\bin\net\4.0\release\log4net.dll'

    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    ScriptsToProcess   = @()

    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()

    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    # NestedModules = @()

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport  = @(
        'Out-Default'
        'Write-Output'
        'Write-Debug'
        'Write-Host'
        'Write-Verbose'
        'Write-Warning'
        'Write-Error'
        'Write-Information'
        'Write-Log'
        'Set-ModuleConfig'
        )

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport    = @()

    # Variables to export from this module
    VariablesToExport  = '*'

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport    = @()

    # DSC resources to export from this module
    # DscResourcesToExport = @()

    # List of all modules packaged with this module
    # ModuleList = @()

    # List of all files packaged with this module
    FileList           = @(
        '.\configs\log4ps_v4.RollingFile.logging_config.xml'
        '.\configs\log4ps_v4.Standard.logging_config.xml'
        '.\en-US\about_log4ps_v4.help.txt'
        '.\lib\log4net-1.2.13\bin\net\4.0\release\log4net.dll'
        '.\lib\log4net-1.2.13\bin\net\4.0\release\log4net.xml'
        '.\lib\log4net-1.2.13\LICENSE'
        '.\lib\log4net-1.2.13\log4net-sdk-net-4.0.chm'
        '.\lib\log4net-1.2.13\NOTICE'
        '.\lib\log4net-1.2.13\README.txt'
        '.\log4ps_v4.psd1'
        '.\log4ps_v4.psm1'
        '.\Private\Clear-Configuration.ps1'
        '.\Private\Get-Logger.ps1'
        '.\Private\Get-RootLogger.ps1'
        '.\Private\Helpers\MethodHelpers\Get-DynamicParamForMethod.ps1'
        '.\Private\Helpers\MethodHelpers\Get-MethodOverloads.ps1'
        '.\Private\Helpers\MethodHelpers\Invoke-MethodOverloadFromBoundParam.ps1'
        '.\Private\Helpers\New-PowerObject.ps1'
        '.\Private\Helpers\Receive-ModuleParameter.ps1'
        '.\Private\Helpers\TypeHelpers\Get-DynamicParamFromTypeName.ps1'
        '.\Private\Helpers\TypeHelpers\New-ObjectInstanceFromTypeNameAndBoundParams.ps1'
        '.\Private\New-Appender.ps1'
        '.\Private\New-Layout.ps1'
        '.\Private\Register-Aliases.ps1'
        '.\Private\Reset-Configuration.ps1'
        '.\Private\Set-BasicConfiguration.ps1'
        '.\Private\Set-RootLogger.ps1'
        '.\Private\Set-XMLConfiguration.ps1'
        '.\Public\ProxyFunctions\Out-Default.ps1'
        '.\Public\ProxyFunctions\Write-Debug.ps1'
        '.\Public\ProxyFunctions\Write-Error.ps1'
        '.\Public\ProxyFunctions\Write-Host.ps1'
        '.\Public\ProxyFunctions\Write-Information.ps1'
        '.\Public\ProxyFunctions\Write-Output.ps1'
        '.\Public\ProxyFunctions\Write-Verbose.ps1'
        '.\Public\ProxyFunctions\Write-Warning.ps1'
        '.\Public\Set-ModuleConfig.ps1'
        '.\Public\Write-Log.ps1'
        '.\README.md'
    )

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData        = @{

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
            ReleaseNotes = @'
08/09/2021 - Created v4. Reorganized module for more accessibility (broke functions into files, restructured psm1).
08/13/2021 - Modified for more strict behavior: StrictMode 3.0, ErrorActionPreference = stop, better exception handling.
'@

        } # End of PSData hashtable

    } # End of PrivateData hashtable

    # HelpInfo URI of this module
    # HelpInfoURI = ''

    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = 'Log4PS'

}