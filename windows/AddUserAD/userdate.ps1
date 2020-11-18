###############################################
#            HUSSON AURELIEN                  #
#     Script create AD User                   #
###############################################

# Import AD module
Import-Module ActiveDirectory

# Do not forget to change the names at the start of the script then the AD descriptor from line 80

$ou = "OU=IT,DC=enterprise,DC=net"
$upnsuffix = "@b2b.entreprise.net"
$prenom=Read-Host "Enter prenom"
$nom=Read-Host "Enter nom"
$webmail="$prenom.$nom@entreprise.net"
$securepwd = ConvertTo-SecureString "PasswuerUser2021" -AsPlainText -Force
$nom = $nom.ToUpper()
$prenom = $prenom.substring(0,1).toupper()+$prenom.substring(1).tolower()
$posdash = $prenom.IndexOf('-')
$indexprenom
$patshhomedir = "\\SRVFILP001"
$datexpiration = "05/12/2020"


if ($posdash -gt "0") # if presence of a - in the first name we concatenate the first letters of the compound first name
    {
        $indexprenom = $prenom.Substring(0,1) + $prenom.Substring(++$posdash,1)
    }
else
    {
        $indexprenom = $prenom.Substring(0,1)
    }

$namedashpos = $nom.IndexOf('-')
$nametmp
for ($n = 0; $namedashpos -gt "0"; $j++)
    {
        if ($namedashpos -gt "0")
            {
                $end = $namedashpos - $n
                $nametmp = $nametmp + $nom.Substring($n,$end)
                $n = $namedashpos + 1
                $namedashpos = $nom.IndexOf('-', $n)
            }
        if ($namedashpos -eq "-1")
            {
                $count = $nom | Measure-Object -Character | select -expandproperty characters
                $count = $count - $n
                $nametmp = $nametmp + $nom.Substring($n,$count)
            }
    }
if ($namedashpos -eq "-1")
    {
       $nametmp = "$nom"
    }

$login = "$nametmp" + "$indexprenom"
$login = $login.ToLower()

$i=2
$origin = $login
while (get-aduser -identity $login)
{
    $login = $origin
    $login = "$login" + "$i"
    $i = $i + 1
}


$userprincipalname = "$login"+"$upnsuffix"
$displayname = "$nom" + ", " + "$prenom" + " (RX)"
$homedir = "$patshhomedir\Users$\" + "$login"

$login = "$login"
$userprincipalname = "$userprincipalname"
$displayname = "$displayname"
$homedir = "$homedir"

#write-host $samaccountname

$Global:result = $null
$date = $null
$description = "CDI"
$bureau = "Paris"
$adresse = "Rue du boulot"
$ville = "Boulogne-Billancourt Cedex"
$company = "Entreprise net Paris"
$emailAddress = "$webmail"
$countryCode = "75008"
$gestionnaire1 = Read-Host "Ecrire l'identifiant AD du manager"
$service = Read-Host "Ecrire la Fonction"
$fonction = Read-Host "Ecrire le Service"

Get-LaunchCreation -prenom $prenom -nom $nom -date $datexpiration -login $login -email "$emailAddress" -phone $phone


write-host "Debut creation compte AD -> $displayname"

New-ADUser -Name "$displayname" -UserPrincipalName "$userprincipalname"  -SamAccountName "$login" -GivenName "$prenom" -Surname "$nom" -DisplayName "$displayname" -Path "$ou" -AccountPassword $securepwd -HomeDirectory "$homedir" -HomeDrive "I:" -Enabled $True -OfficePhone $phone -Description $description -Office $bureau -StreetAddress $adresse -City $ville -EmailAddress $emailAddress -PostalCode $countryCode -Country "FR" -Company $company -title $service -Department $fonction -Manager $gestionnaire1
Add-ADGroupMember -Identity "RX-Entreprise Paris" -Member "$login"

New-Item -Path "$patshhomedir\Users$\" -Name "$login" -ItemType directory
cacls $patshhomedir\Users$\$login /e /g b2b\"$login":R
cacls $patshhomedir\Users$\$login /e /g b2b\"$login":W

write-host "End user AD ..."
