# Add user to Active Directory Account

This script for create user in your AD only (no email) !
Please modify before running !

# Files

 - [ ] userdate : Creates an account with an expiration date.
- [ ] usernodate : Creates an account with no expiration date
  

## Edit file :

    $ou = "OU=IT,DC=enterprise,DC=net" #Change for your OUT
    $upnsuffix = "@b2b.entreprise.net" #Change for your BU
    $webmail="$prenom.$nom@entreprise.net" #Change entreprise.net
    $securepwd = ConvertTo-SecureString "PasswuerUser2021" -AsPlainText -Force # This default password
    $patshhomedir = "\\SRVFILP001" #Change FILE SVR
    $datexpiration = "05/12/2020" #Change Date expiration

**From line 82**

    $description = "CDI" #Add contrat of user
    $bureau = "Paris" #Change the localisation
    $adresse = "Rue du boulot"  #Change adresse
    $ville = "Paris" #Change the city
    $company = "Entreprise net Paris" #Change the name of company
    $emailAddress = "$webmail"
    $countryCode = "75008" #Change country code

