function Set-ModuleConfig
{
    [CmdletBinding(DefaultParameterSetName = 'IncludeProxy')]
    [OutputType([void])]
    param
    (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('FullName', 'Path')]
        [string]
        $ConfigFile = $script:ConfigFile,

        [Parameter(ValueFromPipelineByPropertyName)]
        [switch]
        $DontWatch,

        [Parameter(ValueFromPipelineByPropertyName)]
        [hashtable]
        $ProxyLevelMap = $script:CommandLevelMap,

        [switch]
        $ExcludeWriteProxyFunction,

        [switch]
        $Log4netInternalDebug
    )

    process
    {
        $ModuleName = $PSCmdlet.MyInvocation.MyCommand.Module.Name

        if ($Log4netInternalDebug)
        {
            [log4net.Util.LogLog]::InternalDebugging = $true
        }
        else
        {
            [log4net.Util.LogLog]::InternalDebugging = $false
        }

        Clear-Configuration

        if ($PSBoundParameters.ContainsKey('ProxyLevelMap'))
        {
            $script:CommandLevelMap = $ProxyLevelMap
        }

        # Generate logfile name. Overridden by config.
        $scriptName = $null
        foreach ($stackFrame in Get-PSCallStack)
        {
            try
            {
                $namecandidate = if ($stackFrame.InvocationInfo.ScriptName)
                {
                    $stackFrame.InvocationInfo.ScriptName | Split-Path -Leaf -ErrorAction Ignore
                }

                if ($namecandidate -and ($namecandidate -notmatch 'log4ps_v4|Import-Items|Invoke-psBootstrap'))
                {
                    $scriptName = $namecandidate
                    break
                }
            }
            catch
            {}
        }

        if (-not $scriptName)
        {
            $scriptName = 'CLI'
        }

        $callStack = Get-PSCallStack
        for ($i = 1; $i -le $callStack.Length; $i++)
        {
            if ($callStack[-$i].ScriptName)
            {
                $path = "$(Split-Path $callStack[-$i].ScriptName)\Logs"
                break
            }
        }
        if (-not $path)
        {
            $path = "$env:TEMP\Logs"
        }
        [log4net.GlobalContext]::Properties['LogPath'] = $path
        [log4net.GlobalContext]::Properties['ScriptName'] = $scriptName

        if ($ConfigFile -and -not $DontWatch)
        {
            [log4net.Config.XmlConfigurator]::ConfigureAndWatch((Get-Item $ConfigFile))
        }
        elseif ($ConfigFile)
        {
            [log4net.Config.XmlConfigurator]::Configure((Get-Item $ConfigFile))
        }
        else
        {
            Set-RootLogger
        }

        #NOT IMPLEMENTED YET
        if ($ExcludeWriteProxyFunction)
        {
            'The Write-* functions will NOT be proxied to Log4Net (and removed)' | Microsoft.PowerShell.Utility\Write-Verbose

            foreach ($aliasName in (Get-Command -Module $ModuleName -CommandType Alias -Name 'Write-*').Name)
            {
                Remove-Item "alias:$aliasName" -Force -ErrorAction Ignore
            }
        }
        else
        {
            Register-Aliases -ModuleName $PSCmdlet.MyInvocation.MyCommand.Module.Name # -Prefix 'Log4PS'
        }
    }
}
