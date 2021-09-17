function Register-Aliases
{
    [CmdletBinding()]
    param
    (
        [string]
        $ModuleName = $PSCmdlet.MyInvocation.MyCommand.Module.Name,

        [string]
        $Prefix = $PSCmdlet.MyInvocation.MyCommand.Module.Prefix,

        [string[]]
        [ValidateSet('Write-Host', 'Write-Verbose', 'Write-Debug', 'Write-Warning', 'Write-Error', 'Out-Default', 'Write-Log', 'Write-Information', 'Write-Output')]
        $Streams = @('Write-Host', 'Write-Verbose', 'Write-Debug', 'Write-Warning', 'Write-Error', 'Out-Default', 'Write-Log', 'Write-Information', 'Write-Output')
    )

    process
    {
        foreach ($aliasName in $Streams)
        {
            Remove-Item "alias:$aliasName" -Force -ErrorAction Ignore

            $verb = ($aliasName -split '-')[0]
            $noun = ($aliasName -split '-')[1]

            Set-Alias -Scope Global -Name $aliasName -Value "$ModuleName\$verb-${Prefix}$noun"
        }
    }
}
