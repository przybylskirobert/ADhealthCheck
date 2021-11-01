<#
    .EXAMPLE 
    .\Get-KrbtgtPwdLastSet.ps1 -OutputPath C:\Tools\Audit -Verbose
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
Get-ScriptProgress -Name 'KRBTGT Password Last Set'
Get-ADUser krbtgt -Property PasswordLastSet | Export-Csv -Path $OutputPath\KRGTGT_pwd_details.csv -NoTypeInformation
#endregion 
