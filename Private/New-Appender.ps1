# Create log4net appender object instance with dynamic parameters.
function New-Appender
{
    [CmdletBinding()]
    [OutputType([log4net.Appender.IAppender])]
    param
    (
        [Parameter(
            Mandatory = $true,
            ValueFromPipeLine = $false,
            ValueFromPipelineByPropertyName = $true,
            position = 0
        )]
        [log4net.Appender.Log4PSAppender]
        $AppenderType
    )

    dynamicparam
    {
        if ($type = ("log4net.Appender.$AppenderType" -as [Type]))
        {
            Get-DynamicParamFromTypeName -TypeName $type.ToString()
        }
    }

    process
    {
        $newObjectInstanceFromTypeNameAndBoundParamsHash = @{
            TypeName           = "log4net.Appender.$AppenderType"
            StaticArgumentName = 'AppenderType'
            ParameterSetName   = $PSCmdlet.ParameterSetName
            BoundParameters    = $PSBoundParameters
        }
        New-ObjectInstanceFromTypeNameAndBoundParams @newObjectInstanceFromTypeNameAndBoundParamsHash
    }
}
