<#
    .EXAMPLE 
    .\Get-ServicesOnDC.ps1 -OutputPath C:\Tools\Audit -Verbose
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

Get-ScriptProgress -Name 'DC Services'

$results = @()
$dclist = Get-ADDomainController
foreach ($dc in $dclist) {
    $services = Get-Service -ComputerNAme $dc.Name
    foreach ($service in $services) {
        $svc = $(New-Object PSObject -Property @{
                DomainController = $dc.Name;
                ServiceName      = $service.ServiceName;
                Caption          = $service.DisplayName;
                DisplayName      = $service.DisplayName;
                Description      = $service.description;
                State            = $service.status;
                StartMode        = $service.StartType;
                Path             = ((Get-WmiObject win32_service | where-object { $_.name -match $service.ServiceName }).PathName);
                SerivceAccount   = (Get-WmiObject win32_service | where-object { $_.name -match $service.ServiceName }).StartName
            }
        )
        $results += $svc   
    }
}
$count = ($results | measure-object).count
Write-Host "Found '$count' entries" -ForegroundColor Green
$results  | export-csv -Path $OutputPath\Services_On_DC.csv -NoTypeInformation