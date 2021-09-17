# Write-Log for log4ps
function Write-Log
{
    [CmdletBinding()]
    [OutputType([void])]
    param
    (
        $LoggerName,

        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true,
            ValueFromPipeline = $true
        )]
        $Message,

        [ValidateSet('Debug', 'Info', 'Warn', 'Error', 'Fatal')]
        $LogLevel = 'Info',

        [hashtable]
        $Properties = @{}
    )

    process
    {
        $callStack = Get-PSCallStack

        if
        (
            $callStack[1].Command -eq 'Out-Default' -or
            $callStack[1].Command -eq 'Write-Host' -or
            (Get-Command -Name $callStack[1].Command -ea 0).ModuleName -eq 'log4ps_v4'
        )
        {
            # Internal module caller. (such as proxy function)
            $PSCallStackIndex = 2
        }
        else
        {
            $PSCallStackIndex = 1
        }

        if ($Message.GetType() -eq [System.Management.Automation.ErrorRecord])
        {
            try
            {
                $LoggerName = $callStack[$PSCallStackIndex].ScriptName | Split-Path -Leaf -ErrorAction 'Ignore'
            }
            catch
            {
                $LoggerName = $callStack[$PSCallStackIndex].ScriptName
            }
            $ScriptLineNumber = $callStack[$PSCallStackIndex].ScriptLineNumber.ToString()

            if (-not $LoggerName)
            {
                $LoggerName = 'CLI'
                $ScriptLineNumber = 'host'
            }
        }
        elseif (-not $LoggerName -and $callStack[$PSCallStackIndex].ScriptName)
        {
            # No explicit logger -> autoresolve
            $LoggerName = $callStack[$PSCallStackIndex].ScriptName | Split-Path -Leaf -ErrorAction 'Ignore'
            $ScriptLineNumber = $callStack[$PSCallStackIndex].ScriptLineNumber.ToString()
        }
        elseif (-not $LoggerName)
        {
            $LoggerName = 'CLI'
            $ScriptLineNumber = 'host'
        }

        $logger = Get-Logger -Name $LoggerName

        if ($logger."is$($Loglevel)Enabled")
        {
            $commandCallStack = ($callStack[$PSCallStackIndex..($callStack.Count - 1)] | Where-Object {
                    $_.Command -notmatch '<scriptblock>'
                }).Command

            if ($commandCallStack)
            {
                [array]::Reverse($commandCallStack)
            }

            #[log4net.ThreadContext]::Stacks['Stack'].Push()
            [log4net.ThreadContext]::Properties['ScriptLineNumber'] = $ScriptLineNumber
            [log4net.ThreadContext]::Properties['PSCallStack'] = $commandCallStack -join ' => '

            #Microsoft.PowerShell.Utility\Write-Debug "Logger: $Logger    CommandStack: $($commandCallStack -join ' => ')"
            foreach ($msg in $Message)
            {
                $logger.($LogLevel)($Message)
            }
        }
    }
}
