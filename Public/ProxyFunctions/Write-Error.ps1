<#

.ForwardHelpTargetName Microsoft.PowerShell.Utility\Write-Error
.ForwardHelpCategory Cmdlet

#>
function Write-Error
{
    [CmdletBinding(
        DefaultParameterSetName = 'NoException',
        HelpUri = 'http://go.microsoft.com/fwlink/?LinkID=113425',
        RemotingCapability = 'None'
    )]
    param
    (
        [Parameter(
            ParameterSetName = 'WithException',
            Mandatory = $true
        )]
        [System.Exception]
        $Exception,

        [Parameter(
            ParameterSetName = 'NoException',
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true
        )]
        [Parameter(
            ParameterSetName = 'WithException',
            Mandatory = $false
        )]
        [Alias('Msg')]
        [AllowEmptyString()]
        [AllowNull()]
        [string]
        $Message,

        [Parameter(
            ParameterSetName = 'ErrorRecord',
            Mandatory = $true
        )]
        [System.Management.Automation.ErrorRecord]
        $ErrorRecord,

        [Parameter(ParameterSetName = 'NoException')]
        [Parameter(ParameterSetName = 'WithException')]
        [System.Management.Automation.ErrorCategory]
        $Category,

        [Parameter(ParameterSetName = 'NoException')]
        [Parameter(ParameterSetName = 'WithException')]
        [string]
        $ErrorId,

        [Parameter(ParameterSetName = 'WithException')]
        [Parameter(ParameterSetName = 'NoException')]
        [System.Object]
        $TargetObject,

        [string]
        $RecommendedAction,

        [Alias('Activity')]
        [string]
        $CategoryActivity,

        [Alias('Reason')]
        [string]
        $CategoryReason,

        [Alias('TargetName')]
        [string]
        $CategoryTargetName,

        [Alias('TargetType')]
        [string]
        $CategoryTargetType
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

            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Microsoft.PowerShell.Utility\Write-Error', [System.Management.Automation.CommandTypes]::Cmdlet)
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
                Write-Log -Message $msg -LogLevel $script:CommandLevelMap['Write-Error']
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
