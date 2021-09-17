# Invoke method based on its definition and dynamically given parameters.
function Invoke-MethodOverloadFromBoundParam
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Management.Automation.PSMethod]
        $Method,

        [Parameter(Mandatory, ValueFromPipeline)]
        $Parameters,

        [Parameter(Mandatory, ValueFromPipeline)]
        [string]
        $ParameterSet
    )

    process
    {
        $argumentList = @()

        $parameterNames = $ParameterSet -split '\.'

        foreach ($paramName in $parameterNames)
        {
            $argumentList += $Parameters[$paramName]
        }

        if ($argumentList.count -ge 1)
        {
            $Method.Invoke($argumentList)
        }
        else
        {
            $Method.Invoke()
        }
    }
}
