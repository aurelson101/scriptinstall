##########################################################
## Script for install package desktop for normal user   ##
##########################################################
echo " Install Framework "
winget install --id=Microsoft.dotNetFramework -e ; 
winget install --id=Microsoft.VC++2015Redist-x64 -e ; 
winget install --id=Oracle.JavaRuntimeEnvironment -e ; 

echo " Install Browser "
winget install --id=Mozilla.Firefox -e ; 
winget install --id=Google.Chrome -e ;

echo " Install Security "
winget install --id=Piriform.CCleaner -e ;
winget install --id=WiresharkFoundation.Wireshark -e ;
winget install --id=Bitwarden.Bitwarden -e ;

echo " Install Office "
winget install --id=7zip.7zip -e ; 
winget install --id=VideoLAN.VLC -e ; 
winget install --id=Nextcloud.NextcloudDesktop -e ; 
winget install --id=Rufus.Rufus -e ;
winget install --id=Adobe.AdobeAcrobatReaderDC -e ;
winget install --id=Balena.Etcher -e ; 
winget install --id=SoftDeluxe.FreeDownloadManager -e ;
winget install --id=LibreOffice.LibreOffice -e ; 
winget install --id=Mozilla.Thunderbird -e ; 
winget install --id=GIMP.GIMP -e ; 
winget install --id=Valve.Steam -e ; 
winget install --id=WhatsApp.WhatsApp -e ; 

echo " Install Dev "
winget install --id=TimKosse.FilezillaClient -e ; 
winget install --id=PuTTY.PuTTY -e ;
winget install --id=Microsoft.VisualStudioCode -e ; 
winget install --id=CrystalDewWorld.CrystalDiskInfo -e ; 
winget install --id=angryziber.AngryIPScanner -e ;  
winget install --id=Git.Git -e ;
winget install --id=UltraVNC.UltraVNC -e ; 
winget install --id=TeamViewer.TeamViewer -e ; 
