function Get-DynamicParamFromTypeName
{
    param
    (
        [ValidateScript({$_ -as [type]})]
        [string]
        $TypeName
    )

    function New-ParamAttribute
    {
        param
        (
            [Parameter(
                Mandatory,
                ValueFromPipelineByPropertyName,
                Position = 0
            )]
            [string]
            $ParameterSetName,

            [Parameter(
                Mandatory,
                ValueFromPipelineByPropertyName,
                Position = 1
            )]
            [int]
            $ParamPosition,

            [Parameter(
                ValueFromPipelineByPropertyName,
                Position = 2
            )]
            [switch]
            $DontShow,

            [Parameter(
                ValueFromPipelineByPropertyName,
                Position = 3
            )]
            [bool]
            $Mandatory = $true
        )

        $newAttribute = New-Object System.Management.Automation.ParameterAttribute
        $newAttribute.Mandatory = $Mandatory
        if ($DontShow) {$newAttribute.DontShow = $false}
        $newAttribute.Position = $ParamPosition
        $newAttribute.ParameterSetName = $ParameterSetName

        return $newAttribute
    }

    $paramRuntimeCollection = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

    $type = ($TypeName -as [Type])

    foreach ($constructorDefinition in $(
        $type.GetConstructors().Where({
            if ($_.GetParameters().psobject.Properties['ParameterType'])
            {
                ($_.GetParameters().ParameterType.name -join '') -notmatch '\*'
            }
        })
    ))
    {
        # Remove constructors using pointers.
        $paramListForParamSet = @()
        $paramsInCtor = $constructorDefinition.GetParameters()
        $constructorIndex = $paramsInCtor.Name -join '.'

        foreach ($paramDefinition in $paramsInCtor)
        {
            $paramPosition = 1

            if ($paramRuntimeCollection.Keys -notcontains $paramDefinition.Name)
            {
                $newRuntimeDefinedParameter = New-Object System.Management.Automation.RuntimeDefinedParameter
                $newRuntimeDefinedParameter.Name = $paramDefinition.Name
                $newRuntimeDefinedParameter.ParameterType = $paramDefinition.ParameterType

                $newRuntimeDefinedParameter.Attributes.Add((New-ParamAttribute -ParameterSetName "ctor_$constructorIndex" -ParamPosition $paramPosition))

                if ($paramDefinition.HasDefaultValue)
                {
                    $newRuntimeDefinedParameter.Value = $paramDefinition.DefaultValue
                }

                $paramRuntimeCollection.Add($newRuntimeDefinedParameter.Name, $newRuntimeDefinedParameter)
            }
            else
            {
                "$($paramDefinition.Name) already present in Attribute collection" | Microsoft.PowerShell.Utility\Write-Debug
                "Adding Attribute definition for ParameterSet $($constructorIndex) for Parameter $($paramDefinition.Name)" | Microsoft.PowerShell.Utility\Write-Debug
                $paramRuntimeCollection[$paramDefinition.Name].Attributes.Add((New-ParamAttribute -ParameterSetName "ctor_$constructorIndex" -ParamPosition $paramPosition))
            }

            $paramListForParamSet += $paramDefinition.Name
        }

        $paramPosition++
    }

    $writeableProperties = $type.GetProperties().Where({$_.CanWrite -and $_.Name -notin $paramRuntimeCollection.Keys})

    foreach ($propertyArgument in $writeableProperties)
    {
        $newRuntimeDefinedParameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter
        $newRuntimeDefinedParameter.Name = $propertyArgument.Name
        $newRuntimeDefinedParameter.ParameterType = $propertyArgument.PropertyType

        $newRuntimeDefinedParameter.Attributes.Add((New-ParamAttribute -ParameterSetName '__AllParameterSets' -ParamPosition -2147483648 -Mandatory $false))

        $paramRuntimeCollection.Add($newRuntimeDefinedParameter.Name, $newRuntimeDefinedParameter)
    }

    # Return RuntimeDefinedParameterDictionary. Now accessible in $PSBoundParameters of parent function.
    return $paramRuntimeCollection
}
