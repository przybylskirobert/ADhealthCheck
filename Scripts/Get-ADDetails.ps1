<#
    .EXAMPLE 
    .\Get-ADDetails.ps1 -OutputPath C:\Tools\Audit
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
Get-ScriptProgress -Name 'Forest Info'

$adInfo = @(
    $(New-Object PSObject -Property @{
            ForestName              = $adForest.Name; 
            DomainName              = $adDomain.Name; 
            DomainDistinguishedName = $adDomain.DistinguishedName; 
            DomainFunctionalLevel   = $adDomain.DomainMode; 
            PDC                     = $adDomain.PDCEmulator; 
            RID                     = $adDomain.RIDMaster; 
            InfraMAster             = $adDomain.InfrastructureMaster; 
            ForestFunctionalLevel   = $adForest.ForestMode; 
            ForestSchemaVersion     = (Get-ADObject (Get-ADRootDSE).schemaNamingContext -Property objectVersion).objectVersion; 
            RootDomain              = $adForest.rootDomain; 
            NETBIOS                 = $adDomain.NetBIOSName; 
            SchemaMAster            = $adForest.SchemaMaster; 
            DomainNamingMaster      = $adForest.DomainNamingMaster 
        }
    )
)
$adInfo | Export-Csv -Path $OutputPath\AD_details.csv -NoTypeInformation
#endregion 
