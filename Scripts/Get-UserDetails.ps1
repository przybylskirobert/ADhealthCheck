<#
    .EXAMPLE 
    .\Get-UserDetails.ps1 -OutputPath C:\Tools\Audit -Verbose
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

Get-ScriptProgress -Name 'Users Objects'
$usrReport = @()
$users = get-aduser -Filter * -Properties DistinguishedName, Enabled, Name, ObjectClass, ObjectGUID, SamAccountName, lastLogonTimestamp, pwdLastSet, UserPrincipalName, PrimaryGroup, adminCount, AccountNotDelegated
foreach ($user in $users) {
    $usrName = $user.Name
    $usrReport += New-Object PSObject -Property @{
        'DistinguishedName'      = $user.DistinguishedName
        'Enabled'                = $user.Enabled
        'Name'                   = $user.Name
        'ObjectClass'            = $user.ObjectClass
        'ObjectGUID'             = $user.ObjectGUID
        'SamAccountName'         = $user.SamAccountName
        'lastLogonTimestamp'     = $user.lastLogonTimestamp
        'pwdLastSet'             = $user.pwdLastSet
        'UserPrincipalName'      = $user.UserPrincipalName
        'PrimaryGroup'           = $user.PrimaryGroup
        'adminCount'             = $user.adminCount
        'AccountNotDelegated'    = $user.AccountNotDelegated
    } 
}
$userReportCount = ($usrReport | measure-object).count
Write-Host "Found '$userReportCount' User Accounts" -ForegroundColor Green
$usrReport | export-csv -Path "$OutputPath\User_Details.csv" -NoTypeInformation
