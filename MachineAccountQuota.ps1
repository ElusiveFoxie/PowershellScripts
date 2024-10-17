param(
    [string]$Domain,
    [string]$IP
)

# Split the domain into parts for the DC= format
$domainParts = $Domain -split "\."
$identity = ($domainParts | ForEach-Object { "DC=$_" }) -join ","

Import-Module ActiveDirectory

# Get the domain object and select the ms-DS-MachineAccountQuota property
$quota = Get-DomainObject -Identity $identity -Properties ms-DS-MachineAccountQuota -Domain 1cochran.com -Server $IP |
         Select-Object -ExpandProperty ms-DS-MachineAccountQuota

# Output the quota
$quota
