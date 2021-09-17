# Invoke [log4net.LogManager]::ResetConfiguration with dynamic parameters.
function Reset-Configuration
{
    param()

    dynamicparam
    {
        Get-DynamicParamForMethod -method ([log4net.LogManager]::ResetConfiguration)
    }

    process
    {
        try
        {
            $invokeMethodOverloadFromBoundParamHash = @{
                Method       = ([log4net.LogManager]::ResetConfiguration)
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
