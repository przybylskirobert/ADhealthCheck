<#
    .EXAMPLE 
    .\Get-PSOwithPasswordLenghtBelow8.ps1 -OutputPath C:\Tools\Audit -Verbose
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

#Region Forest Info
Get-ScriptProgress -Name 'PSO with password lenght below 8 characters'

Import-Module ActiveDirectory
$results = @()
$defaultPassword = Get-ADDefaultDomainPasswordPolicy
$ddp = $(New-Object PSObject -Property @{
        Domain                      = (Get-ADDOmain).Forest;
        Name                        = 'Default Password Policy';
        Precedence                  = '';
        PasswordHistory             = $defaultPassword.PasswordHistoryCount;
        MinPasswordAge              = $defaultPassword.MinPasswordAge.Days ;
        MAxPasswordAge              = $defaultPassword.MaxPasswordAge.Days ;
        ComplexityEnabled           = $defaultPassword.ComplexityEnabled;
        ReversibleEncryptionEnabled = $defaultPassword.ReversibleEncryptionEnabled;
        LockoutThreshold            = $defaultPassword.ReversibleEncryptionEnabled;
        LockoutDuration             = $defaultPassword.LockoutDuration.Minutes;
        LockoutObservationWindow    = $defaultPassword.LockoutObservationWindow.Minutes;
        AppliesTo                   = $defaultPassword.DistinguishedName
        MinPasswordLength           = $defaultPassword.MinPasswordLength
    })

$results += $ddp
$psoArray = Get-ADFineGrainedPasswordPolicy -Filter *
foreach ($entry in $psoArray) {
    $pso = $(New-Object PSObject -Property @{
            Domain                      = (Get-ADDOmain).Forest;
            Name                        = $entry.name;
            Precedence                  = $entry.Precedence;
            PasswordHistory             = $entry.PasswordHistoryCount;
            MinPasswordAge              = $entry.MinPasswordAge.Days ;
            MAxPasswordAge              = $entry.MaxPasswordAge.Days ;
            ComplexityEnabled           = $entry.ComplexityEnabled;
            ReversibleEncryptionEnabled = $entry.ReversibleEncryptionEnabled;
            LockoutThreshold            = $entry.ReversibleEncryptionEnabled;
            LockoutDuration             = $entry.LockoutDuration.Minutes;
            LockoutObservationWindow    = $entry.LockoutObservationWindow.Minutes;
            AppliesTo                   = $entry.DistinguishedName
            MinPasswordLength           = $entry.MinPasswordLength
        })
    $results += $pso
}

$results | Where-Object {$_.MinPasswordLength -le 8} | Export-Csv -Path $OutputPath\PSO_with_small_pwd_lenght.csv -NoTypeInformation
#endregion 
