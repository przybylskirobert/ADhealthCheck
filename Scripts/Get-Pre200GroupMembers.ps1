<#
    .EXAMPLE 
    .\Get-Pre200GroupMembers.ps1 -OutputPath C:\Tools\Audit -Verbose
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
Get-ScriptProgress -Name 'Pre-Windows 2000 group members'
Get-ADGroupMember -Identity 'Pre-Windows 2000 Compatible Access' |  Export-Csv -Path $OutputPath\Pre2000_group_members.csv -NoTypeInformation
#endregion 
