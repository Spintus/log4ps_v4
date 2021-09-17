# Invoke [log4net.Config.BasicConfigurator]::Configure with dynamic parameters.

# Overload #1: no params
# Overload #2: appender
# Overload #3: AppenderS
# Overload #4: repository
# Overload #5: repository and appender
# Overload #6: repository and appenders
function Set-BasicConfiguration
{
    [CmdletBinding()]
    param()

    dynamicparam
    {
        Get-DynamicParamForMethod -Method ([log4net.Config.BasicConfigurator]::Configure)
    }

    process
    {
        try
        {
            $invokeMethodOverloadFromBoundParamHash = @{
                Method       = ([log4net.Config.BasicConfigurator]::Configure)
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
