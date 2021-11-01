<#
    .EXAMPLE 
    .\Get-DCUACIssues.ps1 -OutputPath C:\Tools\Audit -Verbose
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
    Write-Host "[$scriptName] Running $name check..." -ForegroundColor Yellow
}
#endregion 

#Region Forest Info
Get-ScriptProgress -Name 'DC UAC Settings'
$dNC = (Get-ADRootDSE).defaultNamingContext
$searchBase = "OU=DOMAIN CONTROLLERS,$dNC"
$dcList = Get-ADComputer -SearchBase $searchBase -properties * -filter *
# 532480, which is (DC + enabled for delegation)
# 83890176, which is (computer account + enabled for delegation + RODC)
$DCwithIssues = $dcList | Where-Object {$_.userAccountControl -ne '532480'} | Format-Table name,DNSHostName,userAccountControl
if ($($DCwithIssues.count) -ne 0) {
    $DCwithIssues | Export-Csv -Path $OutputPath\DC_with_UAC_issues.csv -NoTypeInformation
} else {
   Write-Host "INFO: There are DC's with UAC issues" -ForegroundColor Yellow
}
#endregion 
