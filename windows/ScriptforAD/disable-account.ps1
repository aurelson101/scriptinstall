#This script disable a user or computer account that has not been logged in for 180 days.
#Don't forget to modify OU for your active directory.

$InactivesObjects = Search-ADaccount -AccountInactive -Timespan 180 | Where{ ($_.DistinguishedName -notmatch "CN=Users") -and ($_.Enabled -eq $true) }

Foreach($Object in $InactivesObjects){

  $SamAccountName = $Object.SamAccountName
  $DN = $Object.DistinguishedName
  $ObjectClass = $Object.ObjectClass

  Write-Output "L'objet $SamAccountName est inactif !"

# If is user...
if($ObjectClass -eq "user"){

  # Remove user from groups (but not "Utilisateurs du domaine")
  Get-AdPrincipalGroupMembership -Identity $SamAccountName | Where-Object { $_.Name -Ne "Utilisateurs du domaine" } | Remove-AdGroupMember -Members $SamAccountName -Confirm:$false -ErrorVariable ClearObject

  # Deactivate user
  Set-ADUser -Identity $SamAccountName -Enabled:$false -Description "Désactivé le $(Get-Date -Format dd/MM/yyyy)" -ErrorVariable +ClearObject

# Otherwise, if it's a computer...
}elseif($ObjectClass -eq "computer"){

  # Remove computer from groups (but not "Ordinateurs du domaine")
  Get-AdPrincipalGroupMembership -Identity $SamAccountName | Where-Object { $_.Name -Ne "Ordinateurs du domaine" } | Remove-AdGroupMember -Members $SamAccountName -Confirm:$false -ErrorVariable ClearObject

  # Turn off the computer
  Set-ADComputer -Identity $SamAccountName -Enabled:$false -Description "Désactivé le $(Get-Date -Format dd/MM/yyyy)" -ErrorVariable +ClearObject
}

# Move user / computer
Move-ADObject -Identity "$DN" -TargetPath "OU=Disabled,DC=HOME,DC=LOCAL" -ErrorVariable +ClearObject

if($ClearUser){
  Write-Output "ERREUR ! objet concerné : $SamAccountName ($ObjectClass)"
}else{
  Write-Output "Traitement de l'objet $SamAccountName de type $ObjectClass avec succès ! :-)"
}
  Clear-Variable ClearUser
}