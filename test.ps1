$ErrorActionPreference = 'stop'

Import-Module .\log4ps_v4.psd1 # -Verbose

Write-Debug 'debug'
Write-Verbose 'verbose'
Write-Information 'info'
Write-Warning 'warn'
Write-Error 'error' -ea 2
Write-Output 'output'
Write-Host 'host'
'default' | Out-Default

Get-Module log4ps_v4

Remove-Module log4ps_v4 # -Verbose

Write-Debug 'debug'
Write-Verbose 'verbose'
Write-Information 'info'
Write-Warning 'warn'
Write-Error 'error' -ea 2
Write-Output 'output'
Write-Host 'host'
'default' | Out-Default
