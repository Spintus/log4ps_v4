<#

.ForwardHelpTargetName Microsoft.PowerShell.Utility\Write-Output
.ForwardHelpCategory Cmdlet

#>
function Write-Output
{
    [CmdletBinding(HelpUri = 'https://go.microsoft.com/fwlink/?LinkID=113427', RemotingCapability = 'None')]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [AllowNull()]
        [AllowEmptyCollection()]
        [psobject[]]
        ${InputObject},

        [switch]
        ${NoEnumerate})

    begin
    {
        try
        {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Output', [System.Management.Automation.CommandTypes]::Cmdlet)
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
                    $script:CommandLevelMap['Write-Output']
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
