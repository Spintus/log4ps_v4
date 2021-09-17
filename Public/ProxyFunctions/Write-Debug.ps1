<#

.ForwardHelpTargetName Microsoft.PowerShell.Utility\Write-Debug
.ForwardHelpCategory Cmdlet

#>
function Write-Debug
{
    [CmdletBinding(
        HelpUri = 'http://go.microsoft.com/fwlink/?LinkID=113424',
        RemotingCapability = 'None'
    )]
    param
    (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Alias('Msg')]
        [AllowEmptyString()]
        [string]
        $Message
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

            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Debug', [System.Management.Automation.CommandTypes]::Cmdlet)
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
        foreach ($msg in $message)
        {
            try
            {
                Write-Log -Message $msg -LogLevel $script:CommandLevelMap['Write-Debug']
                $steppablePipeline.Process($msg)
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
