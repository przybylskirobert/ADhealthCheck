<#
    .EXAMPLE 
    .\Get-ADTrusts.ps1 -OutputPath C:\Tools\Audit -Verbose
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
$adDomain = Get-ADDomain
$adForest = Get-ADForest
$scriptName = $myInvocation.ScriptName

function Get-ScriptProgress {
    param (
        [string] $Name
    )   
    Write-Host "[$scriptName] Running $name check..." -ForegroundColor Yellow
}
#endregion 

#region AD Trust
Get-ScriptProgress -Name 'AD Trusts'
$adTrusts = Get-ADTrust -Filter *
Write-Host "Found '$($adTrusts.count)' ADTrust(s)" -ForegroundColor Green
if ($($adTrusts.count) -ne 0) {
    $adTrusts = $adTrusts | Select-Object Source, Target, DistinguishedName, TrustType, Direction, IntraForest, SIDFilteringForestAware, SIDFilteringQuarantined, SelectiveAuthentication
    $adTrusts | Export-Csv -Path $OutputPath\AD_Trusts_details.csv -NoTypeInformation
} else {
   Write-Host "INFO: There are no trusts configured" -ForegroundColor Yellow
}
#endregion
