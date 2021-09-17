# Invoke [log4net.LogManager]::GetLogger with dynamic parameters.
function Get-Logger
{
    [CmdletBinding()]
    param()

    dynamicparam
    {
        Get-DynamicParamForMethod -Method ([log4net.LogManager]::GetLogger)
    }

    process
    {
        try
        {
            $invokeMethodOverloadFromBoundParamHash = @{
                Method       = ([log4net.LogManager]::GetLogger)
                ParameterSet = $PSCmdlet.ParameterSetName
                Parameters   = $PSBoundParameters
            }
            Invoke-MethodOverloadFromBoundParam @invokeMethodOverloadFromBoundParamHash
        }
        catch
        {
            throw
        }
    }
}
