# Part of hacky empty method handling.
if (-not ('Argument' -as [Type]))
{
    if ($PSVersionTable.PSVersion.Major -ge 5)
    {
        Enum Argument {}
    }
    else
    {
        $ArgEnum = @'
public enum Argument
{
}
'@

        Add-Type -TypeDefinition $ArgEnum
    }
}


function Get-MethodOverloads
{
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [System.Management.Automation.PSMethod]
        $Method
    )

    foreach ($signature in $Method.OverloadDefinitions)
    {
        $parameterSet = [ordered] @{}

        # Convert OverloadDefinitions to usable strings.
        [void] ($signature -match '(.*)\((.*)\)')
        $argumentsAsString = $Matches[2] -split ',\s*'

        foreach ($arg in $argumentsAsString)
        {
            # Split string into Name and Type.
            $argName = ($arg -replace '^Params ' -split ' ')[1]
            $argType = ($arg -replace '^Params ' -split ' ')[0]

            if ($null -ne $argName)
            {
                $parameterSet.add($argName, ($argType -as [Type]))
            }
            else
            {
                $parameterSet.add('No', ([Argument])) # hack!
            }
        }

        # Return list of ParameterSet objects as PSCustomObject.
        [PSCustomObject] @{
            'ParameterSetName' = ($parameterSet.Keys -join '.')
            'Params'           = $parameterSet
        } | Add-Member -TypeName custom.method.parameterset -PassThru
    }
}
