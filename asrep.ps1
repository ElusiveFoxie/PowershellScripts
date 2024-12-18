# Add the required .NET assembly
Add-Type -AssemblyName System.DirectoryServices

# Create a DirectoryEntry object for the LDAP path
$domainPath = "LDAP://lab.net"
$directoryEntry = New-Object System.DirectoryServices.DirectoryEntry($domainPath)

# Create a DirectorySearcher object
$searcher = New-Object System.DirectoryServices.DirectorySearcher($directoryEntry)

# Define the LDAP filter for ASREProastable accounts
$searcher.Filter = "(&(objectCategory=person)(objectClass=user)(userAccountControl:1.2.840.113556.1.4.803:=4194304))"

# Specify properties to load
$searcher.PropertiesToLoad.Add("samAccountName") > $null
$searcher.PropertiesToLoad.Add("distinguishedName") > $null

# Perform the search
$results = $searcher.FindAll()

# Output the results
if ($results.Count -gt 0) {
    Write-Host "Found ASREProastable accounts:"
    foreach ($result in $results) {
        $userName = $result.Properties["samAccountName"][0]
        $distinguishedName = $result.Properties["distinguishedName"][0]
        Write-Host "Username: $userName, Distinguished Name: $distinguishedName"
    }
} else {
    Write-Host "No ASREProastable accounts found."
}

# Cleanup
$searcher.Dispose()
$directoryEntry.Dispose()