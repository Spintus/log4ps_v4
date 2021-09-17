function Set-RootLogger
{
    [CmdletBinding()]
    [OutputType([void])]
    param
    (
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Mandatory = $false,
            Position = 0
        )]
        [log4net.Appender.IAppender]
        $Appender = (New-Appender -AppenderType ConsoleAppender -Name ConsoleAppender -layout (New-Layout -LayoutType SimpleLayout))
    )

    process
    {
        $Appender.ActivateOptions()

        $root = [log4net.LogManager]::GetRepository().root

        $root.AddAppender($Appender)
        $root.Hierarchy.Configured = $true
    }
}
