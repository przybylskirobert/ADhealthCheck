<#
    .EXAMPLE 
    .\Get-ADLevels.ps1 -OutputPath C:\Tools\Audit -Verbose
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

Get-ScriptProgress -Name 'AD Levels'
$adLevels = @(
    $(New-Object PSObject -Property @{
            Domain      = $adDomain.Name; 
            ForestLevel = $adforest.ForestMode; 
            DomainLevel = $addomain.DomainMode 
        }
    )
)
$adLevels | Export-Csv -Path $OutputPath\AD_Levels_details.csv -NoTypeInformation
