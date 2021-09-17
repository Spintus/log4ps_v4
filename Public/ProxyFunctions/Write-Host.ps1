<#

.ForwardHelpTargetName Microsoft.PowerShell.Utility\Write-Host
.ForwardHelpCategory Cmdlet

#>
function Write-Host
{
    [CmdletBinding(
        HelpUri = 'http://go.microsoft.com/fwlink/?LinkID=113426',
        RemotingCapability = 'None'
    )]
    param
    (
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromRemainingArguments = $true
        )]
        [System.Object]
        $Object,

        [switch]
        $NoNewline,

        [System.Object]
        $Separator,

        [System.ConsoleColor]
        $ForegroundColor,

        [System.ConsoleColor]
        $BackgroundColor
    )

    begin
    {
        try
        {
            $outBuffer = $null

            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }

            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Host', [System.Management.Automation.CommandTypes]::Cmdlet)
            # $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Output', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters}
            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)

            $steppablePipeline.Begin($PSCmdlet)
        }
        catch
        {
            throw
        }
    }

    process
    {
        foreach ($obj in $object)
        {
            try
            {
                Write-Log -Message $obj -LogLevel $script:CommandLevelMap['Write-Host']
                $steppablePipeline.Process($obj)
            }
            catch
            {
                throw
            }
        }
    }

    end
    {
        try
        {
            $steppablePipeline.End()
        }
        catch
        {
            throw
        }
    }
}
