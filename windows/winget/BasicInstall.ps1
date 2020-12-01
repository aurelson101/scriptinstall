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
winget install --id=Bitwarden.Bitwarden -e ;
winget install --id=Malwarebytes.Malwarebytes -e ;
winget install --id=Piriform.CCleaner -e ;

echo " Install Downloader "
winget install --id=SoftDeluxe.FreeDownloadManager -e ; 

echo " Install Office "
winget install --id=Adobe.AdobeAcrobatReaderDC -e ; 
winget install --id=7zip.7zip -e ; 
winget install --id=TeamViewer.TeamViewer -e ; 
winget install --id=VideoLAN.VLC -e ; 
winget install --id=CrystalDewWorld.CrystalDiskInfo -e ; 
winget install --id=Mozilla.Thunderbird -e ; 
winget install --id=WhatsApp.WhatsApp -eS