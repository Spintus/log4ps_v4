<#

.ForwardHelpTargetName Microsoft.PowerShell.Utility\Write-Information
.ForwardHelpCategory Cmdlet

#>
function Write-Information
{
    [CmdletBinding(HelpUri = 'https://go.microsoft.com/fwlink/?LinkId=525909', RemotingCapability = 'None')]
    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [Alias('Msg')]
        [System.Object]
        ${MessageData},

        [Parameter(Position = 1)]
        [string[]]
        ${Tags}
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
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Information', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters }
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
        foreach ($msg in $MessageData)
        {
            try
            {
                Write-Log -Message $msg -LogLevel $script:CommandLevelMap['Write-Information']
                $steppablePipeline.Process($_)
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
