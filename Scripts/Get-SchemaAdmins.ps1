<#
    .EXAMPLE 
    .\Get-SchemaAdmins.ps1 -OutputPath C:\Tools\Audit -Verbose
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
Get-ScriptProgress -Name 'Schema Admins'
$admins = @()
Get-ADGroupMember -Identity 'Schema Admins' | foreach-object {
   $admins += Get-ADUSer -Identity $_ -Properties Name,Enabled,SamAccountName,LastLogonDate
}
if ($($admins.count) -ne 0) {
    $admins | Export-Csv -Path $OutputPath\Schema_Admins_details.csv -NoTypeInformation
} else {
   Write-Host "INFO: There are no members of Shema Admins group" -ForegroundColor Yellow
}
#endregion 
