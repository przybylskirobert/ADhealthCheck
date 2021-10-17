<#
    .EXAMPLE 
    .\Get-DCFeatures.ps1 -OutputPath C:\Tools\Audit -Verbose
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
    Write-Host "[$scriptName] Running $name check..." -ForegroundColor Yellow
}
#endregion 

Get-ScriptProgress -Name 'Installed DC Features'
$dcList = Get-ADGroupMember -Identity "Domain Controllers"
$tempArray = @{ }
foreach ($dc in $dclist) {
    $dc = $dc.name
    if (Test-Connection -BufferSize 32 -Count 1 -ComputerName $dc -Quiet) {
        $tempArray.add($dc, @())
        $osVersion = (Get-ADComputer -Identity $dc  -Properties *).OperatingSystem
        $tempArray["$dc"] += $osVersion
        Write-Output "Processing $dc ($osVersion)...`n"
        $featuresInstalled = (Get-WmiObject -ComputerName $dc -Query 'select * from win32_serverfeature').Name
        
        ForEach ($featureName in $featuresInstalled) {
            $tempArray["$dc"] += $featureName
        }
    }
    else { 
        Write-Output "Domain Controller $dc ($osVersion) is unavailable`n"
    }
}

$numberOfFeaturesInstalled = $tempArray.Values | ForEach-Object { $_.count } | Sort-Object | Select-Object -last 1

$results = @()
For ($i = 0; $i -lt $numberOfFeaturesInstalled; $i++) {
    $record = New-Object PSObject
    $tempArray.Keys | ForEach-Object { Add-Member -InputObject $record -NotePropertyName $_ -NotePropertyValue $tempArray["$_"][$i] }
    $results += $record
    Clear-Variable Record
}
$results | Export-Csv -Path $OutputPath\DC_Features.csv  -NoTypeInformation
#endregion