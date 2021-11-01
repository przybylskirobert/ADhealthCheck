<#
    .EXAMPLE 
    .\Get-PrivilegedGroupsDetails.ps1 -OutputPath C:\Tools\Audit -Verbose
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

Get-ScriptProgress -Name 'Privileged Groups'

$rootdomainSID = (get-addomain -identity $adForest.RootDomain).DomainSID.value
$Groups = @(
    $(New-Object PSObject -Property @{Name = 'Administrators'; Value = 'S-1-5-32-544' }),
    $(New-Object PSObject -Property @{Name = 'DomainAdmins'; Value = $adDomain.DomainSID.value + "-512" }),
    $(New-Object PSObject -Property @{Name = 'ProtectedUsers'; Value = $adDomain.DomainSID.value + "-525" }),
    $(New-Object PSObject -Property @{Name = 'SchemaAdmins'; Value = $rootdomainSID + "-518" }),
    $(New-Object PSObject -Property @{Name = 'EnterpriseAdmins'; Value = $rootdomainSID + "-519" })
)
$types = @('Group', 'User')
foreach ($group in $groups) {
    foreach ($type in $types) {
        Write-Host "######################   Creating '$($group.Name)' '$type' members report" -ForegroundColor Yellow
        $groupInfo = Get-ADGroupMember -Identity $group.value | where-Object ObjectClass -eq $type
        $groupInfoCount = ($groupInfo | measure-object).count
        Write-Host "Found '$groupInfoCount' '$type' entries" -ForegroundColor Green
        $fileName = "$($Group.Name)" + "_" + "$type"
        if ($($groupInfo.count) -ne 0) {
            $groupInfo | export-csv -Path $OutputPath\Privileged_Groups_Details_$fileName.csv -NoTypeInformation
        } else {
           Write-Host "INFO: Group '$($group.Name)' does not have any '$type' objects'" -ForegroundColor Yellow
        }
    }
}
