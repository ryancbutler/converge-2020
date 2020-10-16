#Installs Citrix Optimizer from a Storage Account and runs with default settings
#Ryan Butler TechDrabble.com @ryan_c_butler 10/03/2020
$ErrorActionPreference="Stop"
$filename = "CitrixOptimizer.zip"
$filepath = "$($env:SystemRoot)\temp"
$storageaccountkey = $env:sakey
$storagecontainer = $env:sacontainer
$saname = $env:storage_account

$downloadpath = "$($env:SystemRoot)\temp\$($filename)"
$unzippath = "$($env:SystemRoot)\temp\CitrixOptimizer"

$StorageContext = New-AzStorageContext -StorageAccountName $saname -StorageAccountKey $storageaccountkey
Get-AzStorageBlobContent -Blob $filename -Container $storagecontainer -Destination $filepath -Context $StorageContext

#Unzip Optimizer. Requires 7-zip!
$UnattendedArgs = " x $downloadpath -o""$unzippath"" -y"
(Start-Process ("$env:ProgramFiles\7-Zip\7z.exe") $UnattendedArgs -Wait -Verbose -Passthru).ExitCode

write-host "Running Optimizer"
& "$unzippath\CtxOptimizerEngine.ps1" -mode Execute
