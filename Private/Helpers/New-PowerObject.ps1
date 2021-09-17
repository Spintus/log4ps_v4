function New-PowerObject
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            position = 0
        )]
        [type]
        $TypeName
    )

    dynamicParam
    {
        function New-ParamAttribute
        {
            param
            (
                [Parameter(
                    Mandatory = $true,
                    ValueFromPipeLine = $false,
                    ValueFromPipelineByPropertyName = $true,
                    position = 0
                )]
                [string]
                $ParameterSetName,

                [Parameter(
                    Mandatory = $true,
                    ValueFromPipeLine = $false,
                    ValueFromPipelineByPropertyName = $true,
                    position = 1
                )]
                [int]
                $ParamPosition,

                [Parameter(
                    Mandatory = $false,
                    ValueFromPipeLine = $false,
                    ValueFromPipelineByPropertyName = $true,
                    position = 2
                )]
                [switch]
                $DontShow,

                [Parameter(
                    Mandatory = $false,
                    ValueFromPipeLine = $false,
                    ValueFromPipelineByPropertyName = $true,
                    position = 3
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

        foreach ($constructorDefinition in $type.GetConstructors().Where({
                if ($baseObject = $_.GetParameters().psobject.BaseObject)
                {
                    if ($baseObject.name -match 'ParameterType')
                    {
                        ($_.GetParameters().ParameterType.name -join '') -notmatch '\*'
                    }
                }
            })
        )
        {
            # Remove constructors using pointers.
            $paramListForParamSet = @()

            $paramsInCtor = $constructorDefinition.GetParameters()
            $constructorIndex = $paramsInCtor.Name -join '.'

            foreach ($paramDefinition in $paramsInCtor)
            {
                $ParamPosition = 1

                if ($paramRuntimeCollection.Keys -notcontains $paramDefinition.Name)
                {
                    $newRuntimeDefinedParameter = New-Object System.Management.Automation.RuntimeDefinedParameter
                    $newRuntimeDefinedParameter.Name = $ParamDefinition.Name
                    $newRuntimeDefinedParameter.ParameterType = $ParamDefinition.ParameterType

                    $newRuntimeDefinedParameter.Attributes.Add((New-ParamAttribute -ParameterSetName "ctor_$constructorIndex" -ParamPosition $ParamPosition))

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
                    $paramRuntimeCollection[$paramDefinition.Name].Attributes.Add((New-ParamAttribute -ParameterSetName "ctor_$constructorIndex" -ParamPosition $ParamPosition))
                }

                $paramListForParamSet += $paramDefinition.Name
            }

            $ParamPosition++
        }

        $writeableProperties = $type.GetProperties().Where({$_.CanWrite -and $_.Name -notin $paramRuntimeCollection.Keys})

        foreach ($propertyArgument in $writeableProperties)
        {
            $newRuntimeDefinedParameter = New-Object -TypeName System.Management.Automation.RuntimeDefinedParameter
            $newRuntimeDefinedParameter.Name = $propertyArgument.Name
            $newRuntimeDefinedParameter.ParameterType = $propertyArgument.PropertyType

            $newRuntimeDefinedParameter.Attributes.Add((New-ParamAttribute -ParameterSetName '__AllParameterSets' -paramPosition -2147483648 -mandatory $false))

            $paramRuntimeCollection.Add($newRuntimeDefinedParameter.Name, $newRuntimeDefinedParameter)
        }

        # Return RuntimeDefinedParameterDictionary. Now accessible in $PSBoundParameters of parent function.
        $paramRuntimeCollection
    }

    process
    {
        $constructorParameterNames = @()
        $parameters = @()

        if ($PSCmdlet.ParameterSetName -match '^ctor_')
        {
            $constructorParameterNames = $PSCmdlet.ParameterSetName -replace '^ctor_' -split '\.'
            [void] $constructorParameterNames.ForEach({$parameters += $PSBoundParameters[$_]; $PSBoundParameters.Remove($_)})#########################
        }

        $instanceOfObject = New-Object -TypeName $type.ToString() -ArgumentList $parameters

        $setProperties = $PSBoundParameters.Keys.Where({
                $_ -ne 'typeName' -and
                $_ -notin [Management.Automation.PSCmdlet]::CommonParameters -and
                $_ -notin [Management.Automation.PSCmdlet]::OptionalCommonParameters
            })

        foreach ($paramPropKey in $setProperties)
        {
            $instanceOfObject.($paramPropKey) = $PSBoundParameters.($paramPropKey)
        }

        $instanceOfObject
    }
}
