<#
    .EXAMPLE 
    .\Get-ADAudit.ps1 -AuditPath C:\Audit 

    .NOTES
    All rigts reserved to 
    Robert Przybylski 
    www.azureblog.pl 
    2021
#>

[CmdletBinding()] 
param (
    [Parameter(Position = 0, mandatory = $true)]
    [string] $AuditPath
)

#region initial setup

$auditFolderTest = Test-Path $AuditPath
if ($auditFolderTest -eq $false) {
    New-Item -Path $AuditPath -Name ADAudit -ItemType Directory -Force | Out-Null
}

$dnsRoot = (Get-ADDomain).dnsroot
$domainAuditPath = "$AuditPath\ADAudit\$dnsRoot"
$DomainFolderTest = Test-Path $domainAuditPath
if ($DomainFolderTest -eq $false) {
    New-Item -path "$AuditPath\ADAudit" -Name $dnsRoot -ItemType Directory -Force | Out-Null
}

$oldLocation = Get-Location

#endregion 

#region transcript
$date = Get-Date -Format "dd_MM_yyyy_HHmm"
$transcriptPath = "$domainAuditPath\ADAudit_$($date).log"
Start-Transcript -Path $transcriptPath
#endregion

#region Audit Scripts run

$scripts = Get-ChildItem -Path .\Scripts\ -File
$scriptsNumber = ($scripts | Measure-Object).count
$i = 1
foreach ($entry in $scripts) {
    $fileName = $entry.Name
    $fileNameClean = [io.path]::GetFileNameWithoutExtension($fileName)
    write-Host "----> Running $fileNameClean script  <-----" -ForegroundColor Green
    . .\Scripts\$fileName -OutputPath $domainAuditPath

}
#end region

Stop-Transcript
Set-Location $oldLocation