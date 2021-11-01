<#
    .EXAMPLE 
    .\Get-Repadim.ps1 -OutputPath C:\Tools\Audit -Verbose
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

#region Repadmin
Get-ScriptProgress -Name 'Replication'
$showrepl = repadmin /showrepl
'repadmin /showrepl' > $OutputPath\Repadim_showrepl.log
$showrepl >> $OutputPath\Repadim_showrepl.log
$replsummary = repadmin /replsummary
'repadmin /replsummary' >> $OutputPath\Repadim_replsummary.log
$replsummary >> $OutputPath\Repadim_replsummary.log
#endregion