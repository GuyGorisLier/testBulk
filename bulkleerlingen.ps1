# Script van Guy Goris om leerlingen in buld in te laden in AD
# Dit is als opgave voor Ken in Netwerkbeheerder
# Alles werkt
# 
# Nog later verder te bekijken:
# -Path => om een niet-standaard map te selecteren doet dit script moeilijk:
# New-ADUser : The operation failed because UPN value provided for addition/modification is not unique forest-wide

$users = Import-csv -Path "C:\00script\LeerlingenCSV.csv"
# The Import-Csv cmdlet provides a way for you to read in data from a comma-separated values file (CSV

# Import-Module ActiveDirectory
# Dit is niet nodig - laad AD DS, mogelijks kan je dit ook laden indien dit niet 
# zo zou zijn =
# If (!(Get-module ActiveDirectory )) 
# {
#     Import-Module ActiveDirectory
# }

# Geeft DC=campus,DC=louis
$OUdomain = Get-ADDomain | select -ExpandProperty DistinguishedName 

# Geeft campus.louis
$domainname = Get-ADDomain | select -ExpandProperty DNSRoot

foreach($user in $users)
{
    $UPassword = $user.password | ConvertTo-SecureString -AsPlainText -Force
    # Waarom pas je deze regel toe?
    # Wat doet deze regel?
    # => MOET VAN HET TYPE SecureString zijn met Force = we zijn er ons van bewust dat dit uit voeren (zie documentatie)

    $Displayname = $user.firstname + " " + $user.Lastname
    $UserFirstname = $user.firstname
    $UserLastname = $user.lastname
    $UPN = $user.Firstname + "." + $user.Lastname + "@" + $domainname

    New-ADUser -DisplayName "$Displayname" -Name "$Displayname" -GivenName "$UserFirstname" -Surname "$UserLastname" -Enabled $True -PasswordNeverExpires $True -CannotChangePassword $True -Path "CN=Users,$OUdomain" -UserPrincipalName "$UPN" -AccountPassword $UPassword
    # let op voor de volgende foutmelding ivm $UPassword
    # New-ADUser : Cannot bind parameter 'AccountPassword'. Cannot convert the "System.Security.SecureString" value of type "System.String" to type "System.Security.SecureString".
    # Oplossing = $UPassword schrijven ipv "
}