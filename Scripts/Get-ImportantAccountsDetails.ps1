<#
    .EXAMPLE 
    .\Get-ImportantAccountsDetails.ps1 -OutputPath C:\Tools\Audit -Verbose
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

Get-ScriptProgress -Name 'Important Accounts'

$results = @()
$passwordPolicy = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days
$pass3x = $passwordPolicy * 3
$staleDate = (Get-Date).AddDays(-$pass3x).ToFileTimeUtc()

$users = Get-ADUser -filter * -Properties *
$admCount = $users | where-object { $_.AdminCount -eq 1 }
$primaryGroup = $users | where-object { $_.primaryGroupID -ne 513 }
$staleUsers = $users | Where-Object { $_.pwdlastset -lt $staleDate -and $_.lastlogontimestamp -lt $staleDate }
$oldPasswordUsers = $users | Where-Object { $_.pwdlastset -lt ((get-date).AddDays(-365)).ToFileTimeUtc() -and $_.enabled -eq $true } | Format-Table *
$uac = $users | Where-Object { $_.useraccountcontrol -band 0x7d00e0 }
$revEncPwdUsers = $users | Where-Object { $_.UserAccountControl -band 0x0080 }
$kerbDesUsers = $users | Where-Object { $_.UserAccountControl -band 0x200000 }
$sidUsers = $users | Where-Object { $_.SIDHistory -like "*" }


$fgppUsers = @()
$fgpp = Get-ADFineGrainedPasswordPolicy -Filter *
foreach ($policy in $fgpp) {
   
    $fgppGroups = Get-ADFineGrainedPasswordPolicySubject -Identity $policy
    $fgppGroups | foreach-object {
        $fgppObjects = Get-ADGroupMember -Identity $_
        $fgppObjects | foreach-object {
                $fgppUsers += Get-ADuser $_.samaccountname -Properties *
        }
    }
}

$results += $admCount
$results += $primaryGroup
$results += $staleUsers
$results += $oldPasswordUsers
$results += $uac
$results += $fgppUsers
$results += $revEncPwdUsers
$resutls += $kerbDesUsers
$results += $sidUsers

$results = $results | Select-Object Name, SamAccountName, DistinguishedName, Description, AdminCount, PasswordLastSet, lastLogonTimestamp, Enabled, CannotChangePassword, PasswordNotRequired, SmartcardLogonRequired, AccountNotDelegated, KerberosEncryptionType, userAccountControl, PrimaryGroup, Modified, created

$count = ($results | measure-object).count
Write-Host "Found '$count' Important Accounts entries" -ForegroundColor Green
$results  | export-csv -Path $OutputPath\Important_Accounts_Details.csv -NoTypeInformation

$importantInfo = @(
    $(New-Object PSObject -Property @{
            AdminCount1Users           = ($admCount | measure-object).count; 
            PrimaryGroupNotDomainUsers = ($primaryGroup | Measure-Object).count; 
            StaleUsers = ($staleUsers | Measure-Object).count; 
            UsersWithOldPassword365 = ($oldPasswordUsers | Measure-Object).count; 
            UACUsers = ($uac | Measure-Object).count; 
            ReversibleEncryptionPasswordUsers = ($revEncPwdUsers | Measure-Object).count; 
            KerberosDESUsers = ($kerbDesUsers | Measure-Object).count; 
            UsersWithSIDHistory = ($sidUsers | Measure-Object).count; 
            FineGrainedPasswordPolicyUsers = ($fgppUsers | Measure-Object).count; 
        }
    )
)
$importantInfo | export-csv -Path $OutputPath\Important_Accounts_Details_sumamry.csv -NoTypeInformation