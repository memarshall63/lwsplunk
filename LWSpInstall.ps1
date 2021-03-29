# Powershell Installation of Splunk Enterprise
#
#
# Used to quickly and easily install Splunk Enterprise on Windows Server.
# Requirements:
#   Internet access to Splunk.com download sites.
#   Disk Space:  XXXXX GB
#   Installation Directory:   C:\Splunk
#


#   Get parameters
#  The only custom parameter establishes whether we're going to install a full version of Splunk or a UF
#  'full' - Full version
#  'uf' - UF Version
param (

    [Parameter(Mandatory=$true)][string]$type
)

if ("full" -eq $type)
{
    $Config = @{
        version = "8.1.3"
        download_file = "splunk-8.1.3-63079c59e632-x64-release.msi"
        download_path = "https://download.splunk.com/products/splunk/releases/#VERSION#/windows/#DOWNLOAD_FILE#"
        installdir = "C:\Splunk\"
        splunk_user = "splunk"
    }
}
else {
    $Config = @{
        download_file = "splunkforwarder-8.1.3-63079c59e632-x64-release.msi"
        download_path = "https://download.splunk.com/products/universalforwarder/releases/#VERSION#/windows/#DOWNLOAD_FILE#"
        installdir = "C:\SplunkForwarder\"
        splunk_user = "splunk"
    }
}    

Write-Information "Config constants:"
$out_str = $Config | Out-String
Write-Information $out_str

$Version = $Config['version']

Write-Output "Downloading...$Config['download_file']"

#    wget "https://download.splunk.com/products/splunk/releases/8.1.3/windows/splunk-8.1.3-63079c59e632-x64-release.msi -outfile splunk-8.1.3-63079c59e632-x64-release.msi"  
$Config['download_path'] = $Config['download_path'].Replace("#VERSION#", $Version)
$Config['download_path'] = $Config['download_path'].Replace("#DOWNLOAD_FILE#", $Config['download_file'])
Write-Information $Config['download_path']
Invoke-WebRequest $Config['download_path'] -outfile $Config['download_file'] 

$install_file = $Config['download_file']
$install_dir = $Config['installdir']
$install_user = $Config['splunk_user']

#Create the install directory - otherwise msi fails cuz can't open log.
if (!(Test-Path $install_dir))
{
    Write-Information "Creating..."
    Write-Information $install_dir
    New-Item -Path $install_dir -ItemType directory | Out-Null
}

$DateStamp = get-date -Format yyyyMMddTHHmmss
$log_file = $install_dir + "$install_file$DateStamp.log"
$MSIArguments = 
    "/i",
    $install_file,
    "AGREETOLICENSE=yes",
    "INSTALLDIR=$install_dir",
    "SPLUNKUSERNAME=$install_user",
    "SPLUNKPASSWORD=$install_user",
    "SERVICESTARTTYPE=manual",
    "LAUNCHSPLUNK=0",
    "/l*v",
    $log_file,
    "/quiet"

  
$out_str = $MSIArguments | Out-String
Write-Information "MSI Arguments:"
Write-Information $out_str
Write-Output "Starting Installation..."
Start-Process -FilePath "msiexec" -ArgumentList $MSIArguments -Wait -NoNewWindow
Write-Output "Completed."

