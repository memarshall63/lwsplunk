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

# Establish some constants.
$Config = @{
    version = "8.1.3"
    download_file_full = "splunk-8.1.3-63079c59e632-x64-release.msi"
    download_path_full = "https://download.splunk.com/products/splunk/releases/#VERSION#/windows/#DOWNLOAD_FILE#"
    installdir_full = "C:\Splunk_Full\"

    download_file_uf = "splunkforwarder-8.1.3-63079c59e632-x64-release.msi"
    download_path_uf = "https://download.splunk.com/products/universalforwarder/releases/#VERSION#/windows/#DOWNLOAD_FILE#"
    installdir_uf = "C:\SplunkForwarder\"
};
Write-Information "Config constants:"
$out_str = $Config | Out-String
Write-Information $out_str

$Version = $Config['version']

Write-Information "Downloading..."
#Write-Information $Config['FullLocation']
#Write-Information $Config['This_Setting']
#Write-Information $Config['OtherSetting1']

#   Download Splunk from Splunk.com
if ( "full" -eq $type)
{
#    wget "https://download.splunk.com/products/splunk/releases/8.1.3/windows/splunk-8.1.3-63079c59e632-x64-release.msi -outfile splunk-8.1.3-63079c59e632-x64-release.msi"  
    $Config['download_path_full'] = $Config['download_path_full'].Replace("#VERSION#", $Version)
    $Config['download_path_full'] = $Config['download_path_full'].Replace("#DOWNLOAD_FILE#", $Config['download_file_full'])
    Write-Information $Config['download_path_full']
    wget $Config['download_path_full'] -outfile $Config['download_file_full'] 
}
else {
    if ("uf" -eq $type)
    {
        $Config['download_path_uf'] = $Config['download_path_uf'].Replace("#VERSION#", $Version)
        $Config['download_path_uf'] = $Config['download_path_uf'].Replace("#DOWNLOAD_FILE#", $Config['download_file_uf'])
        Write-Information $Config['download_path_uf']
        wget $Config['download_path_uf'] -outfile $Config['download_file_uf'] 
    }
    else {
        Write-Error "Invalid Type argument:  must be 'full' or 'uf'."
    }
}


#
#Install Splunk
if ("full" -eq $type)
{
    $install_file = $Config['download_file_full']
    $install_dir = $Config['installdir_full']
}

if ("uf" -eq $type)
{
    $install_file = $Config['download_file_uf']
    $install_dir = $Config['installdir_uf']
}

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
    "INSTALLDIR='$install_dir'",
    "SPLUNKUSERNAME=admin",
    "SPLUNKPASSWORD=splunkadmin",
    "SERVICESTARTTYPE=manual",
    "LAUNCHSPLUNK=0",
    "/l*v",
    $log_file,
    "/quiet"

  
Write-Information "Starting Installation..."
$out_str = $MSIArguments | Out-String
Write-Information "MSI Arguments:"
Write-Information $out_str
Start-Process -FilePath "msiexec" -ArgumentList $MSIArguments -Wait -NoNewWindow
Write-Information "Completed."

