<#
    .EXAMPLE 
    .\Get-AccountsWithNeverExpirePasswords.ps1 -OutputPath C:\Tools\Audit
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
Get-ScriptProgress -Name 'Accounts with never expire passwords'
$userList = Get-ADUSer -filter * -Properties Name,PasswordNeverExpires,Created,DistinguishedName,LastLogonDate,Enabled
$neverExpireUsers = $userList | where-object {$_.PasswordExpired -ne $true}
$result = $neverExpireUsers | select-object Name,PasswordNeverExpires,Created,DistinguishedName,LastLogonDate,Enabled | where-object {$_.PasswordNeverExpires -eq $true -and $_.Enabled -eq $true}
$result  | Export-Csv -Path $OutputPath\Accounts_With_Never_Expire_Password_details.csv -NoTypeInformation
#endregion 
