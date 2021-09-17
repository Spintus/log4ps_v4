<#

.ForwardHelpTargetName Microsoft.PowerShell.Core\Out-Default
.ForwardHelpCategory Cmdlet

#>
function Out-Default
{
    [CmdletBinding(
        HelpUri = 'http://go.microsoft.com/fwlink/?LinkID=113362',
        RemotingCapability = 'None'
    )]
    param
    (
        [switch]
        $Transcript,

        [Parameter(ValueFromPipeline)]
        [psobject]
        $InputObject
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

            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Core\Out-Default', [System.Management.Automation.CommandTypes]::Cmdlet)
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
        foreach ($obj in $InputObject)
        {
            try
            {
                $loglevel = if ($obj.getType() -eq [System.Management.Automation.ErrorRecord])
                {
                    'FATAL'
                }
                else
                {
                    $script:CommandLevelMap['Out-Default']
                }

                Write-Log -Message $obj -LogLevel $loglevel
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
