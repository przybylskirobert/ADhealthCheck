<#
    .EXAMPLE 
    .\Get-SysvolDetails.ps1 -OutputPath C:\Tools\Audit -Verbose
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

#region Sysvol
$state = DfsrMig /GetGlobalState
$result = @()
if($state -like "DFSR migration has not yet initialized*"){
    $result = $(New-Object PSObject -Property @{
        Domain = (Get-ADDomain).DNSRoot;
        'FRS Replication' = $true;
        'DFSR Replication' = $false;
        }
    )
}else{
    $result = $(New-Object PSObject -Property @{
        Domain = (Get-ADDomain).DNSRoot;
        'FRS Replication' = $false;
        'DFSR Replication' = $true;
        }
    )
}
$result | export-csv -Path $OutputPath\Sysvol_details.csv -NoTypeInformation
#endregion
