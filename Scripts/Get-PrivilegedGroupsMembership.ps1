<#
    .EXAMPLE 
    .\Get-PrivilegedGroupsMembership.ps1 -OutputPath C:\Tools\Audit -Verbose
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

Get-ScriptProgress -Name 'Privileged Groups Membership'


$privilegedGroups = @(
    $(New-Object PSObject -Property @{SID = $adSid + "-512"; Name = "Domain Admins" }),
    $(New-Object PSObject -Property @{SID = $adSid + "-514"; Name = "Domain Guests" }),
    $(New-Object PSObject -Property @{SID = $adSid + "-516"; Name = "Domain Controllers" }),
    $(New-Object PSObject -Property @{SID = $adSid + "-517"; Name = "Cert Publishers" }),
    $(New-Object PSObject -Property @{SID = $adSid + "-520"; Name = "Group Policy Creator Owners" }),
    $(New-Object PSObject -Property @{SID = $adSid + "-553"; Name = "RAS and IAS Servers" }),
    $(New-Object PSObject -Property @{SID = $adSid + "-498"; Name = "Enterprise Read-only Domain Controllers" }),
    $(New-Object PSObject -Property @{SID = $adSid + "-521"; Name = "Read-only Domain Controllers" }),
    $(New-Object PSObject -Property @{SID = $adSid + "-571"; Name = "Allowed RODC Password Replication Group" }),
    $(New-Object PSObject -Property @{SID = $adSid + "-572"; Name = "Denied RODC Password Replication Group" }),
    $(New-Object PSObject -Property @{SID = $adSid + "-522"; Name = "Clonable Domain Controllers" }),
    $(New-Object PSObject -Property @{SID = $adSid + "-525"; Name = "Protected Users" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-544" ; Name = "Administrators" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-546" ; Name = "Guests" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-547" ; Name = "Power Users" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-548" ; Name = "Account Operators" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-549" ; Name = "Server Operators" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-550" ; Name = "Print Operators" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-551" ; Name = "Backup Operators" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-552" ; Name = "Replicators" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-554" ; Name = "Pre-Windows 2000 Compatible Access" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-555" ; Name = "Remote Desktop Users" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-556" ; Name = "Network Configuration Operators" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-558" ; Name = "Performance Monitor Users" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-559" ; Name = "Performance Log Users" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-560" ; Name = "Windows Authorization Access Group" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-561" ; Name = "Terminal Server License Servers" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-562" ; Name = "Distributed COM Users" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-568" ; Name = "IIS_IUSRS" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-569" ; Name = "Cryptographic Operators" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-573" ; Name = "Event Log Readers" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-574" ; Name = "Certificate Service DCOM Access" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-575" ; Name = "RDS Remote Access Servers" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-576" ; Name = "RDS Endpoint Servers" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-577" ; Name = "RDS Management Servers" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-578" ; Name = "Hyper-V Administrators" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-579" ; Name = "Access Control Assistance Operators" }),
    $(New-Object PSObject -Property @{SID = "S-1-5-32-580" ; Name = "Remote Management Users" }),
    $(New-Object PSObject -Property @{SID = "SIDunknown" ; Name = "Debugger Users" }),
    $(New-Object PSObject -Property @{SID = "SIDunknown" ; Name = "DHCP Administrators" }),
    $(New-Object PSObject -Property @{SID = "SIDunknown" ; Name = "DHCP Users" }),
    $(New-Object PSObject -Property @{SID = "SIDunknown" ; Name = "DnsAdmins" }),
    $(New-Object PSObject -Property @{SID = "SIDunknown" ; Name = "DnsUpdateProxy" }),
    $(New-Object PSObject -Property @{SID = "SIDunknown" ; Name = "Exchange Domain Servers" }),
    $(New-Object PSObject -Property @{SID = "SIDunknown" ; Name = "Exchange Enterprise Servers" })
)

$results = @()
foreach ($group in $privilegedGroups) {
    $sid = $group.sid
    $name = $group.name
    Write-Host "Working on group '$name'"
    if ($sid -eq 'SIDunknown') {
        try {
            Get-ADGRoup -identity 'Debugger Users'
        }
        catch {
            $groupChecker = $null
        }
        if ($groupChecker -ne $null){
            $selectedGroup = Get-ADGRoup -identity $name
            if ($null -ne $selectedGroup) {
                $selectedGroupMemebers = $selectedGroup | Get-ADGroupMember
                foreach ($member in $selectedGroupMemebers) {
                    Write-Host "Working on object '$($member.SamAccountName )'"
                    $grp = $null
                    $grp = $(New-Object PSObject -Property @{
                            Domain          = $domain; 
                            GroupName       = $selectedGroup.Name; 
                            AccountName     = $member.Name; 
                            SamAccountName  = $member.SamAccountName; 
                            AccountDN       = $member.distinguishedName;
                            SPN             = $member.ServicePrincipalName;
                            ComputeroObject = (Get-ADObject -filter { (objectclass -eq 'group') -or (objectclass -eq 'user') -or (objectclass -eq 'computer') } | Where-Object { $_.Name -eq $member.name } ).objectclass
                        }
                    )
                    $results += $grp  
                }
            }
            else {
                continue
            }
        }
    }

    $selectedGroup = Get-ADGRoup -filter * | Where-Object { $_.sid -eq $sid }
    if ($null -ne $selectedGroup) {

        $selectedGroupMemebers = $selectedGroup | Get-ADGroupMember
        foreach ($member in $selectedGroupMemebers) {
            Write-Host "Working on object '$($member.SamAccountName )'"
            $grp = $null
            $grp = $(New-Object PSObject -Property @{
                    Domain          = $domain; 
                    GroupName       = $selectedGroup.Name; 
                    AccountName     = $member.Name; 
                    SamAccountName  = $member.SamAccountName; 
                    AccountDN       = $member.distinguishedName;
                    SPN             = $member.ServicePrincipalName.value;
                    ComputeroObject = (Get-ADObject -filter { (objectclass -eq 'group') -or (objectclass -eq 'user') -or (objectclass -eq 'computer') } | Where-Object { $_.Name -eq $member.name } ).objectclass
                }
            )
            $results += $grp  
           
        }
    }
    else {
        continue
    }
}

$count = ($results | measure-object).count
Write-Host "Found '$count' entries" -ForegroundColor Green
$results  | export-csv -Path $OutputPath\PrivilegedGroupsMembership.csv -NoTypeInformation