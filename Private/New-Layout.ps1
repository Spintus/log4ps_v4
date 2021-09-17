# Create log4net layout object instance with dynamic parameters.
function New-Layout
{
    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory = $false,
            ValueFromPipeLine = $false,
            ValueFromPipelineByPropertyName = $true,
            position = 0
        )]
        [log4net.Layout.Log4PSLayout]
        $LayoutType = [log4net.Layout.Log4PSLayout]::SimpleLayout
    )

    dynamicparam
    {
        if ($PSBoundParameters.Keys -notcontains 'LayoutType')
        {
            $LayoutType = [log4net.Layout.Log4PSLayout]::SimpleLayout
        }

        $type = ("log4net.Layout.$LayoutType" -as [Type])
        Get-DynamicParamFromTypeName -TypeName $type.ToString()
    }

    process
    {
        $newObjectInstanceFromTypeNameAndBoundParamsHash = @{
            TypeName           = "log4net.Layout.$LayoutType"
            StaticArgumentName = 'LayoutType'
            ParameterSetName   = $PSCmdlet.ParameterSetName
            BoundParameters    = $PSBoundParameters
        }
        New-ObjectInstanceFromTypeNameAndBoundParams @newObjectInstanceFromTypeNameAndBoundParamsHash
    }
}
