<#
    .EXAMPLE 
    .\Get-BackupInfo.ps1 -OutputPath C:\Tools\Audit -Verbose
    .NOTES
    All rigts reserved to 
    Robert Przybylski 
    www.azureblog.pl 
    2021
#>

[CmdletBinding()] 
param (
    [Parameter(Position = 0, mandatory = $true)]
    [string] $OutputPath = "C:\Temp\ADAudit\mvp.azureblog.pl"
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

Get-ScriptProgress -Name 'Backup Info'
$dcList = Get-ADGroupMember -Identity "Domain Controllers"
$result = @()
$dclist | ForEach-Object {
    $backups = repadmin.exe /showbackup $_.name
    $cleanedBackups = $backups | where{$_ -ne ""}
    for ($i = 0; $i -lt $cleanedBackups.Count; $i++) { 
        
        if ($cleanedBackups[$i] -match '^(CN|DC)') {           
            $backupPartition = $cleanedBackups[$i]
            $backupDateTime = [regex]::Match($cleanedBackups[$i + 1], '(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})').Groups[1].Value
             $result += $(New-Object PSObject -Property @{DomainController = $_.name; Partition = $backupPartition; DateTime = $backupDateTime})
        }
    }
}
$result | Export-Csv -Path $OutputPath\Backup_Info.csv  -NoTypeInformation