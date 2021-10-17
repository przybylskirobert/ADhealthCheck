<#
    .EXAMPLE 
    .\Get-ComputerDetails.ps1 -OutputPath C:\Tools\Audit -Verbose
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

Get-ScriptProgress -Name 'Computer Objects'
$CompReport = @()
$domain = (Get-ADDomain).DNSRoot
$computers = Get-ADComputer -Filter * -Properties DistinguishedName, Enabled, DNSHostName, Name, ObjectClass, ObjectGUID, SamAccountName, OperatingSystem, OperatingSystemVersion, lastLogonTimestamp, pwdLastSet
foreach ($computer in $computers) {
    $cmpDNS = $computer.DNSHostName
    $cmpName = $computer.Name
    $CompReport += New-Object PSObject -Property @{
        'Domain'                 = $domain
        'DistinguishedName'      = $computer.DistinguishedName
        'Enabled'                = $computer.Enabled
        'DNSHostName'            = $cmpDNS
        'Name'                   = $computer.Name
        'ObjectClass'            = $computer.ObjectClass
        'ObjectGUID'             = $computer.ObjectGUID
        'SamAccountName'         = $computer.SamAccountName
        'OperatingSystem'        = $computer.OperatingSystem
        'OperatingSystemVersion' = $computer.OperatingSystemVersion
        'lastLogonTimestamp'     = $computer.lastLogonTimestamp
        'pwdLastSet'             = $computer.pwdLastSet
    }
}
$compReportCount = ($CompReport | measure-object).count
Write-Host "Found '$compReportCount' Computer Accounts" -ForegroundColor Green
$CompReport | export-csv -Path $OutputPath\Computer_Objets.csv -NoTypeInformation