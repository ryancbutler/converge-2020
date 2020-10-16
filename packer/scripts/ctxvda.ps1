#Installs Citrix VDA from a Storage Account
#Ryan Butler TechDrabble.com @ryan_c_butler 10/03/2020

$filename = $env:vda
$UnattendedArgs = "/quiet /optimize /components vda /controllers '$env:vdacontrollers' /enable_remote_assistance /enable_hdx_ports /enable_real_time_transport /virtualmachine /noreboot /noresume /logpath 'C:\Windows\Temp\VDA' /masterimage"
$filepath = "$($env:SystemRoot)\temp"
$storageaccountkey = $env:sakey
$storagecontainer = $env:sacontainer
$saname = $env:storage_account
$ErrorActionPreference="Stop"

if (Test-Path ("C:\ProgramData\Citrix\XenDesktopSetup\XenDesktopVdaSetup.exe"))
{
	Write-Host "File already exists. Resuming install"
	$exit = (Start-Process ("C:\ProgramData\Citrix\XenDesktopSetup\XenDesktopVdaSetup.exe") -Wait -Verbose -Passthru).ExitCode
}
else
{
    Write-Host "Downloading $filename"
    $StorageContext = New-AzStorageContext -StorageAccountName $saname -StorageAccountKey $storageaccountkey
    Get-AzStorageBlobContent -Blob $filename -Container $storagecontainer -Destination $filepath -Context $StorageContext

	Write-Host "Installing VDA..."
	$exit = (Start-Process ("$filepath\$filename") $UnattendedArgs -Wait -Verbose -Passthru).ExitCode
}

if ($exit -eq 0)
{
	Write-Host "VDA INSTALL COMPLETED!"
}
elseif ($exit -eq 3)
{
	Write-Host "REBOOT NEEDED!"
}
elseif ($exit -eq 1)
{
	#dump log
	Get-Content "C:\Windows\Temp\VDA\Citrix\XenDesktop Installer\XenDesktop Installation.log"
	throw "Install FAILED! Check Log"
}
