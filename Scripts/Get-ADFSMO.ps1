<#
    .EXAMPLE 
    .\Get-ADFSMO.ps1 -OutputPath C:\Tools\Audit -Verbose
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

#region FSMO
Get-ScriptProgress -Name 'FSMO Roles'

$fsmoRoles = @(
    $(New-Object PSObject -Property @{
            SchemaMaster_F         = $adForest.SchemaMaster; 
            DomainNamingMaster_F   = $adforest.DomainNamingMaster; 
            PDC_D                  = $addomain.PDCEmulator; 
            RIDPoolMaster_D       = $addomain.RIDMaster; 
            InfrastructureMaster_D  = $addomain.InfrastructureMaster 
        }
    )
)
$fsmoRoles | Export-Csv -Path $OutputPath\AD_FSMO_details.csv -NoTypeInformation

#endregion