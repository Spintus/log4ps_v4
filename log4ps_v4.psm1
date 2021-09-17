<# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
All imported *script* modules suffer from a massive known issue in Powershell
(All versions as of Core 7.1)!

In short: the common parameter inheritence mechanism is fundamentally broken
for advanced functions under certain circumstances. For reference, see:
https://github.com/PowerShell/PowerShell/issues/4568

For example: When $ErrorActionPreference is set to 'Stop', compiled cmdlets
will honor that preference by terminating on most* errors. Advanced functions
imported from a module however, which are meant to behave identically to
compiled cmdlets, will not. For 'why', if you want brain damage, see:
https://seeminglyscience.github.io/powershell/2017/09/30/invocation-operators-states-and-scopes

*https://github.com/MicrosoftDocs/PowerShell-Docs/issues/1583

This means preference variables are unreliable! For critical scripts, caution
MUST be taken to ensure good behavior in regard to preference variables.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #>

# Capture args to variable.
param ()
$script:ModuleParams = $args

# Map PowerShell streams to log4net levels.
$script:CommandLevelMap = @{
    'Write-Error'       = 'Error'
    'Write-Warning'     = 'Warn'
    'Write-Output'      = 'Info'
    'Out-Default'       = 'Info'
    'Write-Host'        = 'Info'
    'Write-Information' = 'Info'
    'Write-Verbose'     = 'Debug'
    'Write-Debug'       = 'Debug'
}

#requires -Version 5.1
$ErrorActionPreference = 'Stop'
Microsoft.PowerShell.Core\Set-StrictMode -Version 3

# If debugging, set moduleRoot to current directory.
$moduleRoot = if ($MyInvocation.MyCommand.Path)
{
    Microsoft.PowerShell.Management\Split-Path -Path $MyInvocation.MyCommand.Path
}
else
{
    $PWD.Path
}

# Define enums for appender + layout types
if (-not ('log4net.Appender.Log4PSAppender' -as [Type]))
{
    $availableAppenders = ([reflection.assembly]::GetAssembly([log4net.Appender.AppenderSkeleton]).DefinedTypes) |
        Where-Object {
            $_.IsSubclassOf([log4net.Appender.AppenderSkeleton]) -and -not $_.isAbstract
        }

    $AppenderTypeEnum = @"
namespace log4net.Appender
{
    public enum Log4PSAppender
    {
        $($availableAppenders.Name -join ",`r`n")
    }
}
"@

    Add-Type -TypeDefinition $AppenderTypeEnum -ErrorAction Ignore
    Remove-Variable -Name availableAppenders -Force
}

if (-not ('log4net.Layout.Log4PSLayout' -as [Type]))
{
    $availableLayouts = ([reflection.assembly]::GetAssembly([log4net.Layout.LayoutSkeleton]).DefinedTypes) |
        Where-Object {
            $_.IsSubclassOf([log4net.Layout.LayoutSkeleton]) -and -not $_.isAbstract
        }

    $LayoutTypeEnum = @"
namespace log4net.Layout
{
    public enum Log4PSLayout
    {
        $($availableLayouts.Name -join ",`r`n")
    }
}
"@

    Add-Type -TypeDefinition $LayoutTypeEnum -ErrorAction Ignore
    Remove-Variable -Name availableLayouts -Force
}

<# !!! NOT IMPLEMENED !!!
# Add extension methods for instances of ILog that accept lambdas.
# With C# 3.0+ can defer message formatting until needed (if at all).
Add-Type -TypeDefinition @'
using log4net;


namespace Log4NetExtensions
{
    public static class Log4NetExtensionMethods
    {
        public static void Debug( this ILog log, Func<string> formattingCallback )
        {
            if( log.IsDebugEnabled )
            {
                log.Debug( formattingCallback() );
            }
        }
        public static void Info( this ILog log, Func<string> formattingCallback )
        {
            if( log.IsInfoEnabled )
            {
                log.Info( formattingCallback() );
            }
        }
        public static void Warn( this ILog log, Func<string> formattingCallback )
        {
            if( log.IsWarnEnabled )
            {
                log.Warn( formattingCallback() );
            }
        }
        public static void Error( this ILog log, Func<string> formattingCallback )
        {
            if( log.IsErrorEnabled )
            {
                log.Error( formattingCallback() );
            }
        }
        public static void Fatal( this ILog log, Func<string> formattingCallback )
        {
            if( log.IsFatalEnabled )
            {
                log.Fatal( formattingCallback() );
            }
        }
     }
}
'@ -Language CSharp -ErrorAction Ignore #>

# Get all function scripts for dot-sourcing. Grouped for order of loading and exporting.
$proxies = @(Microsoft.PowerShell.Management\Get-ChildItem -Path "$moduleRoot\Public\ProxyFunctions\*.ps1")
$helpers = @(Microsoft.PowerShell.Management\Get-ChildItem -Path "$moduleRoot\Private\Helpers\*.ps1" -Recurse)
$private = @(Microsoft.PowerShell.Management\Get-ChildItem -Path "$moduleRoot\Private\*.ps1")
$public  = @(Microsoft.PowerShell.Management\Get-ChildItem -Path "$moduleRoot\Public\*.ps1")

# Dot source helper function scripts.
foreach ($import in @($helpers)) {. $import}

# Dot source function scripts.
foreach ($import in @($private + $public)) {. $import}

# Dot source proxy functions now that Write-Log is defined.
foreach ($import in @($proxies)) {. $import}

# Configure now that functions are defined.
Receive-ModuleParameter

if ((Get-Variable -Scope script -Name 'ParamsForSetModuleConfig' -ea 4) -and
    $script:ParamsForSetModuleConfig.Count -gt 0)
{
    Set-ModuleConfig @script:ParamsForSetModuleConfig
}
else
{
    Set-ModuleConfig #-Log4netInternalDebug
}

# Remove aliases once module is removed.
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    Clear-Configuration

    $aliases = @(
        'alias:Write-Host'
        'alias:Write-Warning'
        'alias:Write-Debug'
        'alias:Write-Error'
        'alias:Write-Verbose'
        'alias:Write-Log'
        'alias:Write-Information'
        'alias:Write-Output'
        'alias:Out-Default'
    )

    $aliases | ForEach-Object {
        while (Test-Path $_)
        {
            Remove-Item $_ -ErrorAction Ignore -Force
        }
    }
}

# Export only the public functions.
Microsoft.PowerShell.Core\Export-ModuleMember -Function @($public.BaseName + $proxies.BaseName)
