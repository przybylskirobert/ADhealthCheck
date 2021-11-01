<#
    .EXAMPLE 
    .\Get-LAPS.ps1 -OutputPath C:\Tools\Audit -Verbose
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

Get-ScriptProgress -Name 'LAPS'

$lapsTest = get-module AdmPwd.PS -ErrorAction SilentlyContinue
if ($null -ne $lapsTest) {
    $lapsInfo = Get-ADOrganizationalUnit -Filter * | Find-AdmPwdExtendedRights -PipelineVariable OU | ForEach-Object {
        $_.ExtendedRightHolders | ForEach-Object {
            [pscustomobject]@{
                OU     = $Ou.ObjectDN
                Object = $_
            }
        }
    }
        
}
else {
    $LapsInfo = New-Object PSObject -Property @{
        Info = "Laps not installed / found"
    }
}
$lapsInfo | export-csv -Path $OutputPath\LAPS.csv -NoTypeInformation
#endRegion