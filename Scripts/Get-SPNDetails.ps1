<#
    .EXAMPLE 
    .\Get-SPNDetails.ps1 -OutputPath C:\Tools\Audit -Verbose
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

#region SPN
Get-ScriptProgress -Name 'SPN'
$spn = Get-ADUser -LDAPFilter '(servicePrincipalName=*)' -Properties servicePrincipalName 
$spnCount = ($spn | measure-object).count
Write-Host "Found '$spnCount' SPN entries" -ForegroundColor Green
$spns = Get-ADUser -LDAPFilter '(servicePrincipalName=*)' -Properties servicePrincipalName 
$result = @()
foreach ($entry in $spns) {
    $result += @(
        $(New-Object PSObject -Property @{
                DistinguishedName    = $entry.DistinguishedName;
                Enabled              = $entry.Enabled;
                GivenName            = $entry.GivenName;
                Name                 = $entry.Name;
                ObjectClass          = $entry.ObjectClass;
                ObjectGUID           = $entry.ObjectGUID;
                SamAccountName       = $entry.SamAccountName;
                servicePrincipalName = $entry.servicePrincipalName.value;
                SID                  = $entry.SID;
                Surname              = $entry.Surname;
                UserPrincipalName    = $entry.UserPrincipalName;
            }
        )
    )
}
$result | export-csv -Path $OutputPath\SPN_details.csv -NoTypeInformation
#endregion