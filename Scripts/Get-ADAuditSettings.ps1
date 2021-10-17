<#
    .EXAMPLE
    $AuditSettings = @("Authentication Policy Change" , "Computer Account Management" , "DPAPI Activity" , "Kerberos Authentication service" , "Kerberos Service Ticket Operations" , "Logoff" , "Logon" , "Process Creation" , "Security Group Management" , "Security System Extension" , "Sensitive Privilege Use" , "Special Logon" , "User Account Management")
    .\Get-ADAuditSettings -AuditSettings $AuditSettings -OutputPath "C:\tools"

#>
param (
    [string[]] $AuditSettings = @("Authentication Policy Change" , "Computer Account Management" , "DPAPI Activity" , "Kerberos Authentication service" , "Kerberos Service Ticket Operations" , "Logoff" , "Logon" , "Process Creation" , "Security Group Management" , "Security System Extension" , "Sensitive Privilege Use" , "Special Logon" , "User Account Management"),
    [string] $OutputPath = "C:\tools"
)

$dclist = Get-ADDomainController
$tempStatusCSV = "$OutputPath\tempdcstatus.csv" 
$auditFile = "$OutputPath\AuditSettings.csv"

if ((Test-Path -LiteralPath $auditFile) -eq $false) {
    New-Item -ItemType File -Path $auditFile | out-null
}

$headers = "Domain Controller, " + ($AuditSettings -join ", ")
Add-Content $auditFile $headers

Foreach ($dc in $dclist) {
    $dcName = $dc.Name
    Write-Host "Checking DC '$dcName'" -ForegroundColor Green
    $tempTable = @()
    $dcStatusArray = @()
    $auditStatus = Invoke-Command -ComputerName $dcName -Script { auditpol.exe /get /Category:* /r }
    $auditStatus > $tempStatusCSV 
    $auditStatusCSV = Import-CSV -path $tempStatusCSV
    foreach ($entry in $auditStatusCSV) {
        $subcategory = $entry.Subcategory
        $inclusionSetting = $entry.'Inclusion Setting'
        $tempTable += $(New-Object PSObject -Property @{DCName = $dcName; subcategory = $entry.Subcategory; "Inclusion Setting" = $inclusionSetting })
    }
    foreach ($setting in $AuditSettings) {
        $dcStatusArray += $tempTable | Where-Object { $_.subcategory -eq $setting }
    }
    $str = $dcName 
    foreach ($subcategory in $dcStatusArray) {
        Write-Host "Building Results string for for category '$($subcategory.subcategory)'" -ForegroundColor Yellow
        $str = $str + ", " + $subcategory.'Inclusion Setting'
    }
    Add-Content $auditFile $str
}
Remove-Item -LiteralPath $tempStatusCSV
Write-Host "AuditSettings.csv file updated and temporary file removed" -ForegroundColor Green
