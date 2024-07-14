$StartSearch="C:\"
$ExportFile="C:\Windows\Tasks\report.csv"

$Extension = @("*.ps1","*.cmd","*.vbs","*.bat")

ForEach ($File in (get-childitem -recurse -path $StartSearch -include $Extension -ErrorAction silentlycontinue)) {

   $Acl = Get-Acl -Path $File.FullName
   ForEach ($Access in $Acl.Access) {
$Item = New-Object -TypeName PSObject

 $Item| Add-Member Noteproperty ScanTime -Value $(Get-Date -Format "dd/MM/yyyy HH:mm K")
 $Item| Add-Member Noteproperty FileName -Value $File.FullName
 $Item| Add-Member Noteproperty Group -Value $Access.IdentityReference
 $Item| Add-Member Noteproperty Permissions -Value $Access.FileSystemRights
 $Item| Add-Member Noteproperty Inherited -Value $Access.IsInherited
 $Item| Add-Member Noteproperty LastWriteTime -Value $File.LastWriteTimeUtc
 $Item| Add-Member Noteproperty CreatedOn -Value $File.CreationTimeUtc
 $Item| Add-Member Noteproperty CreateBy -Value $Acl.Owner
 

 $Item | Export-Csv -Path $ExportFile -Append -Force -Encoding ASCII -NoTypeInformation 
 }
}
