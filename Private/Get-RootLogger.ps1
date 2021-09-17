# Define function wrappers for dll.
function Get-RootLogger
{
    [CmdletBinding()]
    [OutputType([log4net.ILog])]
    param()

    [log4net.LogManager]::GetRepository().root
}
