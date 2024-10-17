param(
    [string]$Domain,
    [string]$IP
)

Import-Module ActiveDirectory

# Retrieve and filter domain computers based on the operating system
$computers = Get-DomainComputer -Domain $Domain -Server $IP |
             Where-Object {
                 $_.OperatingSystem -Match "Windows Server 2003" -or
                 $_.OperatingSystem -Match "Windows Server 2008" -or
                 $_.OperatingSystem -Match "Windows XP" -or
                 $_.OperatingSystem -contains "Windows Vista" -or
                 $_.OperatingSystem -Match "Windows 7" -or
                 $_.OperatingSystem -contains "Windows 8"
             } |
             Select-Object cn, OperatingSystem, operatingsystemservicepack

# Format and output the filtered list
$computers | Format-List *
