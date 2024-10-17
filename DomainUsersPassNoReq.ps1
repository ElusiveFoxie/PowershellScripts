param(
    [string]$Domain,
    [string]$IP
)

Import-Module ActiveDirectory

Get-DomainObject -Domain $Domain -Server $IP -ldapfilter "(&(objectCategory=person)(objectClass=user)(userAccountControl:1.2.840.113556.1.4.803:=32))" -properties samaccountname, useraccountcontrol
