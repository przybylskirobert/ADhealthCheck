<#
    .EXAMPLE 
    .\Get-InactiveDCs.ps1 -OutputPath C:\Tools\Audit -Verbose
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

#Region Forest Info
Get-ScriptProgress -Name 'Inactive DCs'
$dNC = (Get-ADRootDSE).defaultNamingContext
$timeframe = (Get-Date).AddDays(-30)
$searchBase = "OU=DOMAIN CONTROLLERS,$dNC"
$dcList = Get-ADComputer -SearchBase $searchBase -properties * -filter *
#$dcList | select-object name,DNSHostName,LastLogonDate | Where-Object {$_.LastLogonDate -lt $timeframe -or $_.LastLogonDate -eq $null}
$oldDCs = $dcList | Where-Object {$_.LastLogonDate -lt $timeframe -or $_.LastLogonDate -eq $null}
if ($oldDCs -ne $null){
    $oldDCs | select-object name,DNSHostName,LastLogonDate | Export-Csv -Path $OutputPath\Inactive_DCs_details.csv -NoTypeInformation
} else {
   Write-Host "INFO: There are no inactive DCs'" -ForegroundColor Yellow
}
#endregion 
