<#
    .EXAMPLE 
    .\Get-NotSensitivePrivilegedUsers.ps1 -OutputPath C:\Tools\Audit -Verbose
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
Get-ScriptProgress -Name 'Get-NotSensitivePrivilegedUsers'
$groups = @(
    'Account Operators',
    'Administrators',
    'Backup Operators',
    'DnsAdmins',
    'Domain Admins',
    'Enterprise Admins',
    'Enterprise Key Admins',
    'Key Admins',
    'Print Operators',
    'Replicator',
    'Schema Admins',
    'Server operators',
    'Protected Users'
)

$privilegedUsers = @()

foreach($group in $groups){
    $groupMembers = Get-ADGroupMember -Identity $group -ErrorAction SilentlyContinue -Recursive
    $groupMembers | ForEach-Object {
        $samaccountname = $_.samaccountname
        $name = $_.name
        $usr = Get-ADUser -Identity $samaccountname -Properties samaccountname,distinguishedName,AccountNotDelegated
        $distinguishedName = $usr.distinguishedName
        $AccountNotDelegated = $usr.AccountNotDelegated
        $privilegedUsers += $(New-Object PSObject -Property @{Name = $name; samaccountname = $samaccountname; OUPrefix = $distinguishedName; AccountNotDelegated = $AccountNotDelegated })
    } 
}

$notSensitivePrivilegedAccounts = $privilegedUsers | Where-Object {$_.AccountNotDelegated -eq $false}
if (($notSensitivePrivilegedAccounts | Measure-Object).lenght -gt 0){
    $notSensitivePrivilegedAccounts | Export-Csv -Path $OutputPath\Not_Sensitive_Privileged_Users.csv -NoTypeInformation
}
#endregion 
