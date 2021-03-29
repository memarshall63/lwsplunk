== README ==

LWSPInstall.ps1

Lightwell Splunk Installation power shell script.
03/29/2021 - MM

This script will install the full or forwarder version of Splunk on a Windows machine.
The script assumes:
    Access to the Internet
    Administrative Rights
    At least 100 MB of free disk space

Run Options:

PS> .\LWSPInstall.ps1
-or-
PS> .\LWSPInstall.ps1 full

Install the full version of Splunk*.   @Config array in the script can be modified to pick a different
version, package, URI location, or splunk user/password to use.  You can also select install folder.
For the full version C:\Splunk is default.   Splunk user:  splunkadmin  (password is same.)

PS> .\LWSPInstall.ps1 uf

Install the Universal Forwarder (agent version) of Splunk.  @Config contains the same options.
Default folder location will be C:\SplunkForwarder

Script runs relatively quiet but:

PS> .\LWSPInstall.ps1 full -InformationAction Continue

.. will turn on INFO level console output.    msiexec.exe also runs with a verbose log file being
outputted to the install directory with the filename:

splunk-8.1.3-63079c59e632-x64-release.msi20210329T153417.log  (or similar depending on the version.)

*WINDOWS & Splunk

Full version of Splunk on Windows is a pretty miserable affair.   The full version can be run on a local
machine as a Heavy Forwarder, or the UF version is pretty typical for a Windows machine in a larger Splunk 
implementation.  However, if this full version is meant to be THE primary splunk core node of any real scale,
 -- think twice and run a standalone Linux server.  

 MM.
 

