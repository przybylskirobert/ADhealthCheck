<#
    .EXAMPLE 
    .\Get-SPNDuplicatesDetails.ps1 -OutputPath C:\Tools\Audit -Verbose
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
Get-ScriptProgress -Name 'SPN Duplicates'

$spn = SetSPN -X -F | Where-Object { $_ -notlike "Processing entry*" }
if ($spn[3] -ne 'found 0 group of duplicate SPNs.'){
    $spn  | Export-Csv -Path $OutputPath\SPN_Duplicates_details.csv -NoTypeInformation
}
#endregion 
