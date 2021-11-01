<#
    .EXAMPLE 
    .\Get-DCwithSpooler.ps1 -OutputPath C:\Tools\Audit -Verbose
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
$adDomain = Get-ADDomain
$adForest = Get-ADForest
$scriptName = $myInvocation.ScriptName

function Get-ScriptProgress {
    param (
        [string] $Name
    )   
    Write-Host "[$scriptName] Running $name check..." -ForegroundColor Yellow
}
#endregion 

#Region Forest Info
Get-ScriptProgress -Name 'Spooler Service'
$DCList = Get-ADGroupMember -Identity 'Domain Controllers'
$dcswithPrintSpooler = @()
$DCList | ForEach-Object {
    $name = $_.Name
    $service = Get-Service -ComputerName $name -DisplayName "Print Spooler" 
    $serviceName = $service.name
    $serviceStatus = $service.Status
    $dcswithPrintSpooler = $(New-Object PSObject -Property @{
            DCName        = $name
            ServiceName   = $serviceName
            ServiceStatus = $serviceStatus
        }
    )
} 
$dcswithPrintSpooler = $dcswithPrintSpooler | where-object {$_.serviceStatus -eq 'Running'} 
if ($($dcswithPrintSpooler.count) -ne 0) {
    $dcswithPrintSpooler | Export-Csv -Path $OutputPath\DCs_with_spooler.csv -NoTypeInformation
} else {
   Write-Host "INFO: There are DC's with print spooler service running" -ForegroundColor Yellow
}
#endregion 
