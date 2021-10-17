<#
    .EXAMPLE 
    .\Get-DefaultContainers.ps1 -OutputPath C:\Tools\Audit -Verbose
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
$addomain = Get-ADDomain
$scriptName = $myInvocation.ScriptName
function Get-ScriptProgress {
    param (
        [string] $Name
    )   
    Write-Host "[$scriptName] Running $name check..." -ForegroundColor Yellow
}
#endregion 

Get-ScriptProgress -Name 'Default Containers'
$defaultContainers = @(
    $(New-Object PSObject -Property @{
            DomainName        = $adDomain.Name; 
            UsersContainer    = $adDomain.UsersContainer; 
            ComputerContainer = $adDomain.ComputersContainer 
        })
)
$defaultContainers | Export-Csv -Path $OutputPath\Default_Containers.csv -NoTypeInformation
