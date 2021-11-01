<#
    .EXAMPLE 
    .\Get-GMSADetails.ps1 -OutputPath C:\Tools\Audit -Verbose
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

Get-ScriptProgress -Name 'GMSA'
$output = @()
$gmsaReport = Get-ADServiceAccount -Filter * -Properties * 
Write-Host "Found '$($gmsaReport.count)' GMSA Accounts" -ForegroundColor Green
if ($($gmsaReport.count) -ne 0 ) {
    $gmsaReport | ForEach-Object {
        $output += New-Object PSObject -Property @{
            Name = $_.name;
            DistinguishedName  = $_.DistinguishedName 
            DnsHostName = $_.DNSHostName
            Enabled = $_.Enabled
            AllowedPrincipals = $_.PrincipalsAllowedToRetrieveManagedPassword -join ";"
            Sid = $_.SID
            SamAccountName = $_.SamAccountName
        }
    }
    $output | export-csv -Path $OutputPath\GMSA_Details.csv -NoTypeInformation
} else {
    Write-Host "INFO: There are no GMSA accounts" -ForegroundColor Yellow
}