<#
    .EXAMPLE 
    .\Get-XXX.ps1 -OutputPath C:\Tools\Audit -Verbose
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
    Write-Verbose "[$scriptName] Running $name check..."
}
#endregion 

#Region Forest Info
Get-ScriptProgress -Name 'XXXX'

$result  | Export-Csv -Path $OutputPath\XXX_details.csv -NoTypeInformation
#endregion 
