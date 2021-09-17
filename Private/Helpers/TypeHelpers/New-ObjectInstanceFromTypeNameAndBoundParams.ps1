function New-ObjectInstanceFromTypeNameAndBoundParams
{
    param
    (
        [Parameter(Mandatory, Position = 0)]
        #[validateScript({$_ -as [type]})]
        [string]
        $TypeName,

        [Parameter(Mandatory, Position = 1)]
        [string[]]
        $StaticArgumentName,

        [Parameter(Mandatory, Position = 2)]
        [string]
        $ParameterSetName,

        [Parameter(Mandatory, Position = 3)]
        [ValidateNotNullOrEmpty()]
        [hashtable]
        $BoundParameters
    )

    process
    {
        $constructorParameterNames = @()

        if ($ParameterSetName -match '^ctor_')
        {
            $constructorParameterNames = $ParameterSetName -replace '^ctor_' -split '\.'

            $parameters = @()

            $constructorParameterNames.ForEach({$parameters += $BoundParameters[$_]; $BoundParameters.Remove($_)})
            $instanceOfObject = New-Object -TypeName $TypeName -ArgumentList $parameters
        }
        else
        {
            $instanceOfObject = New-Object -TypeName $TypeName
        }

        $setProperties = $BoundParameters.Keys.Where({$_ -notin $StaticArgumentName -and $_ -notin [System.Management.Automation.PSCmdlet]::CommonParameters -and $_ -notin [System.Management.Automation.PSCmdlet]::OptionalCommonParameters})

        foreach ($ParamPropKey in $setProperties)
        {
            $instanceOfObject.($ParamPropKey) = $BoundParameters.($ParamPropKey)
        }

        return $instanceOfObject
    }
}
