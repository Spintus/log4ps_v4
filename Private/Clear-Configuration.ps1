function Clear-Configuration
{
    [OutputType([void])]
    param()

    process
    {
        try
        {
            try
            {
                if ($loggers = if ([log4net.LogManager]::GetCurrentLoggers().psobject.Properties['logger']) {[log4net.LogManager]::GetCurrentLoggers().logger})
                {
                    $loggers.removeAllAppenders()
                }
            }
            catch {}

            [log4net.LogManager]::ShutdownRepository()
            [log4net.LogManager]::Shutdown()
            [log4net.LogManager]::ResetConfiguration()
        }
        catch
        {
            throw
        }
    }
}
