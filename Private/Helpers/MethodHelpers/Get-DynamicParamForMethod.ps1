# Help construct function signature based on method.
function Get-DynamicParamForMethod
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Management.Automation.PSMethod]
        $Method
    )

    process
    {
        $paramRuntimeCollection = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        $overloadMethods = Get-MethodOverloads -Method $Method

        foreach ($overload in $overloadMethods)
        {
            $parameterSetName = $overload.ParameterSetName

            foreach ($parameter in $overload.Params.Keys)
            {
                if (-not $paramRuntimeCollection.ContainsKey($parameter))
                {
                    $attribute = (New-PowerObject -TypeName System.Management.Automation.ParameterAttribute -ParameterSetName $parameterSetName -Mandatory $true -Position 0)

                    # hack for empty method signature. See Get-MethodOverloads.ps1 for rest of jank.
                    if ($parameter -eq 'no' -and $overload.Params[$Parameter].ToString() -eq 'Argument')
                    {
                        $attribute.Mandatory        = $false
                        $attribute.DontShow         = $true
                        $attribute.ParameterSetName = 'NoArguments'
                    }

                    $newParam = New-PowerObject -TypeName System.Management.Automation.RuntimeDefinedParameter -name $parameter -parameterType ($Overload.Params[$parameter] -as [Type]) -attributes @($attribute)

                    $paramRuntimeCollection.Add($parameter, $newParam)
                }
                else
                {
                    $attribute = (New-PowerObject -TypeName System.Management.Automation.ParameterAttribute -ParameterSetName $parameterSetName -Mandatory $true)

                    #TODO: edit the position of the parameter for this parameterset
                    $paramRuntimeCollection[$parameter].Attributes.Add($attribute)
                }
            }
        }

        $paramRuntimeCollection
    }
}
