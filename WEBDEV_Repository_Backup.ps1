<#
.SYNOPSIS
WEBDEV_Repository_Backup

.DESCRIPTION
This Powershell script backs up all files and directories inside the htdocs folder 
from Apache Httpd Server to WEBDEV folder located deep within POST-COLYMPIC ERA.
#>

# The source path of Apache Httpd folder is assigned to $ApacheHttpd variable.
$ApacheHttpd = "C:\Apache24\htdocs"

# The destination path of WEBDEV folder is assigned to $WebDev variable.
$WebDev = "D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\WEBDEV"

# The first Test-Path cmdlet checks if the $ApacheHttpd variable does not exist with ! operator. If true, then it is non-existent 
# and an error message is triggered indicating that the htdocs of Apache Httpd Server does not exist. Otherwise, it goes to else.
if (!(Test-Path $ApacheHttpd))
{
	Write-Error "The WEBDEV Repository Backup cannot be performed because htdocs folder of Apache Httpd Server does not exist. Please install Apache Httpd Server on this System PC."
}
else
{
	# The second Test-Path cmdlet checks if the $WebDev variable does not exist with ! operator. If true, the non-existing 
	# destination path will be created with the New-Item cmdlet in addition to -ItemType parameter set to Directory, -Path 
	# parameter is $WebDev variable, and -Force parameter without any prompt.
	if (!(Test-Path $WebDev))
	{
		New-Item -ItemType Directory -Path $WebDev -Force
	}
	
	# robocopy copies everything from source path ($ApacheHttpd) to destination path ($WebDev) with /e means recursion.
	robocopy $ApacheHttpd $WebDev /e
	
	# Write-Host cmdlet displays a confirmation that the WEBDEV Repository Backup script runs successfully on current date with 
	# Get-Date cmdlet plus -ForegroundColor set to Blue and -BackgroundColor set to Magenta adding emphasis on the confirmation.
	# `n represents newline character.
	Write-Host "`nWEBDEV Repository Backup from htdocs folder of Apache Httpd Server was completed on $(Get-Date)." -ForegroundColor Blue -BackgroundColor Magenta
}