<#

.ForwardHelpTargetName Microsoft.PowerShell.Utility\Write-Warning
.ForwardHelpCategory Cmdlet

#>
function Write-Warning
{
    [CmdletBinding(
        HelpUri = 'http://go.microsoft.com/fwlink/?LinkID=113430',
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

            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Warning', [System.Management.Automation.CommandTypes]::Cmdlet)
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
        foreach ($msg in $Message)
        {
            try
            {
                Write-Log -Message $msg -LogLevel $script:CommandLevelMap['Write-Warning']
                $steppablePipeline.Process($Message)
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
