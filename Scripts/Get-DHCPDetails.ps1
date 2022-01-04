<#
    .EXAMPLE 
    .\Get-DHCPDetails.ps1 -OutputPath C:\Tools\Audit -Verbose
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

Get-ScriptProgress -Name 'DHCP'
$searchBase = "cn=configuration," + $adDomain.DistinguishedName
$dhcplist = Get-ADObject -SearchBase $searchBase  -Filter "objectclass -eq 'dhcpclass' -AND Name -ne 'dhcproot'"
$dhcpTest = $dhcplist.count
if ($dhcpTest -ne 0) {
    $dhcpReport = $dhcplist 
        
}
else {
    $dhcpReport = New-Object PSObject -Property @{
        Info = "There are no authorised DHCP Servers"
    }
}
$dhcpReport | export-csv -Path $OutputPath\DHCP_Details.csv -NoTypeInformation