# Add the required .NET assembly
Add-Type -AssemblyName System.DirectoryServices

# Create a DirectoryEntry object for the LDAP path
$domainPath = "LDAP://lab.net"
$directoryEntry = New-Object System.DirectoryServices.DirectoryEntry($domainPath)

# Create a DirectorySearcher object
$searcher = New-Object System.DirectoryServices.DirectorySearcher($directoryEntry)

# Define the LDAP filter to find users with an SPN set
$searcher.Filter = "(&(objectCategory=person)(objectClass=user)(servicePrincipalName=*))"

# Specify properties to load
$searcher.PropertiesToLoad.Add("samAccountName") > $null
$searcher.PropertiesToLoad.Add("servicePrincipalName") > $null
$searcher.PropertiesToLoad.Add("distinguishedName") > $null

# Perform the search
$results = $searcher.FindAll()

# Output the results
if ($results.Count -gt 0) {
    Write-Host "Found users with SPN set:"
    foreach ($result in $results) {
        $userName = $result.Properties["samAccountName"][0]
        $spnList = $result.Properties["servicePrincipalName"]
        $distinguishedName = $result.Properties["distinguishedName"][0]
        Write-Host "Username: $userName, Distinguished Name: $distinguishedName"
        Write-Host "SPNs: $($spnList -join ', ')"
    }
} else {
    Write-Host "No users with SPN set found."
}

# Cleanup
$searcher.Dispose()
$directoryEntry.Dispose()