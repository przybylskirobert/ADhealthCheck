<#
    .EXAMPLE 
    .\Get-UsersWithAdminCount.ps1 -OutputPath C:\Tools\Audit -Verbose
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
    Write-Host "[$scriptName] Running $name check..." -ForegroundColor Yellow}
#endregion 

#Region Forest Info
Get-ScriptProgress -Name 'Get Users with Admin Count = 1'

Get-ADUser -filter * -properties * |where-object {$_.admincount -eq 1} | Select-Object name,distinguishedname | Export-Csv -Path $OutputPath\Users_With_Admin_Count_details.csv -NoTypeInformation
#endregion 
