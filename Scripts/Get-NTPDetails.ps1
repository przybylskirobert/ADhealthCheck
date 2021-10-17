<#
    .EXAMPLE 
    .\Get-NTPDetails.ps1 -OutputPath C:\Tools\Audit -Verbose
    .NOTES
    All rigts reserved to 
    Robert Przybylski 
    www.azureblog.pl 
    2021
#>

[CmdletBinding()] 
param (
    [Parameter(Position = 0, mandatory = $true)]
    [string] $OutputPath
)

#region initial setup
Import-Module ActiveDirectory
$scriptName = $myInvocation.ScriptName

function Get-ScriptProgress {
    param (
        [string] $Name
    )   
    Write-Host "[$scriptName] Running $name check..." -ForegroundColor Yellow}
#endregion 

Get-ScriptProgress -Name 'NTP Configurtion'
$ntpConfig = w32tm /query /configuration 
'w32tm /query /configuration' > $OutputPath\NTP_configuration.log
$ntpConfig >> $OutputPath\NTP_configuration.log
$ntpStatus = w32tm /query /status
'w32tm /query /status' >> $OutputPath\NTP_details.log
$ntpStatus >> $OutputPath\NTP_details.log