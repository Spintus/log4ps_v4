# Invoke [log4net.Config.XmlConfigurator]::Configure with dynamic parameters.

# Overload #1: No Parameter
# Overload #2: repository
# Overload #3: element
# Overload #4: repository and element
# Overload #5: ConfigFile
# Overload #6: URI
# Overload #7: ConfigStream
# Overload #8: Repository and Configfile
# Overload #9: Repository and ConfigURI
# Overload #10: repository and ConfigStream
function Set-XMLConfiguration
{
    [CmdletBinding(DefaultParametersetName = 'A')]
    param()

    dynamicparam
    {
        Get-DynamicParamForMethod -Method ([log4net.Config.XmlConfigurator]::Configure)
    }

    process
    {
        try
        {
            $invokeMethodOverloadFromBoundParamHash = @{
                Method       = ([log4net.Config.XmlConfigurator]::Configure)
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
