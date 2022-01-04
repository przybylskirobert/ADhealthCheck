<#
    .EXAMPLE 
    .\Get-AuthenticationPolicyDetails.ps1 -OutputPath C:\Tools\Audit -Verbose
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

Get-ScriptProgress -Name 'Authentication Policy'
#region AuthenticationPolicy
$ADAuthenticationPolicy = Get-ADAuthenticationPolicy -Filter * | select-object Name, Enforce, UserTGTLifetimeMins
Write-Host "Found '$($ADAuthenticationPolicy.count)' Authentication Policy entries" -ForegroundColor Green
if ($($ADAuthenticationPolicy.count) -ne 0) {
    $ADAuthenticationPolicy | export-csv -Path $OutputPath\Authentication_Policy_Details.csv -NoTypeInformation
}
Get-ScriptProgress -Name 'Authentication Policy Silo'
$ADAuthenticationPolicySilo = Get-ADAuthenticationPolicySilo -Filter * |  select-object  Name, Enforce, UserTGTLifetimeMins
Write-Host "Found '$($ADAuthenticationPolicySilo.count)' Authentication Policy Silo entries" -ForegroundColor Green
if ($($ADAuthenticationPolicySilo.count) -ne 0) {
    $ADAuthenticationPolicySilo | export-csv -Path $OutputPath\Authentication_Policy_Details_Silo.csv -NoTypeInformation
}
