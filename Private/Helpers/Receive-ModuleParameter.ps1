function Receive-ModuleParameter
{
    param
    (
        $ModuleParams = $script:ModuleParams
    )

    if ($ModuleParams.count -eq 0)
    {
        # If no arguments, look for config file based on $PSScriptRoot and fileName.
        $callStack = Get-PSCallStack
        $callerFile = if ($callStack[$callstack.Count - 1].ScriptName)
        {
            $callStack[$callstack.Count - 1].ScriptName
        }
        else
        {
            $callStack[$callstack.Count - 2].ScriptName
        }

        try
        {
            [string] $callerFileRoot = Split-Path $callerFile
        }
        catch
        {
            Microsoft.PowerShell.Utility\Write-Warning $_
        }

        if ($callerFile -and
            (
                # Most of these are unneccesary. Remove if causes issues or decide on standard.
                ($CallerFileName = Resolve-Path "$callerFileRoot\logging_config.xml" -ea Ignore) -or
                ($CallerFileName = Resolve-Path "$callerFileRoot\Dependencies\$callerFile.config" -ea Ignore) -or
                ($CallerFileName = Resolve-Path "$callerFileRoot\Dependencies\${callerFile}_config.xml" -ea Ignore) -or
                ($CallerFileName = Resolve-Path "$callerFileRoot\Dependencies\$callerFile.config.xml" -ea Ignore) -or
                ($CallerFileName = Resolve-Path "$callerFileRoot\Dependencies\logging_config.xml" -ea Ignore)
            )
        )
        {
            $script:configFile = $CallerFileName.Path
        }
        else
        {
            Microsoft.PowerShell.Utility\Write-Verbose 'No configuration file found, and No arguments sent. Loading hardcoded defaults'
            $script:configFile = $null
        }
    }
    elseif ($ModuleParams.count -eq 1)
    {
        # If one argument, check if it's a hashtable.
        if ($ModuleParams[0] -as [hashtable])
        {
            # If hashtable, extract valid params for splatting to the Set-<moduleName>ModuleConfig function.
            $moduleName = $MyInvocation.MyCommand.ModuleName
            $ConfigCommand = Get-Command "Set-$($moduleName)ModuleConfig"

            $script:ParamsForSetModuleConfig = @{}

            foreach ($moduleParamKey in $ModuleParams.keys)
            {
                # Extract allowed parameters from Module Arguments.
                if ($moduleParamKey -in $ConfigCommand.Parameters.Keys)
                {
                    $script:ParamsForSetModuleConfig.add($moduleParamKey, $ModuleParams.($moduleParamKey))
                }
                else
                {
                    Microsoft.PowerShell.Utility\Write-Warning -Message "Parameter $param was found but not allowed for Set-$($moduleName)ModuleConfig"
                }
            }

            # Call to config need to happen at the end of the psm1 file so that all functions are defined.
        }
        else
        {
            # Only one argument but not a Hashtable, maybe it's a configuration file.
            if ($null -ne $ModuleParams[0] -and
                $ModuleParams[0] -ne [string]::Empty -and
                ($configFileName = Resolve-Path $ModuleParams[0])
            )
            {
                $script:configFile = $configFileName.Path
            }
        }
    }
}
