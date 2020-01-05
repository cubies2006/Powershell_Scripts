<#
.SYNOPSIS
FindingAllExpiredCertificates

.DESCRIPTION
This Powershell function retrieves the expiration dates, the thumbprints, and the subjects
of all expired certificates.

First, Push-Location cmdlet saves the current location.

Second, Set-Location cmdlet redirects from the current path to Cert:\ drive.

Third, dir alias retrieves every certificate in the currentuser store beginning at the root 
level through its -Recurse parameter.

Fourth, the where alias contains a script block which states that the certificate store must 
be filtered out through !$_.psicontainer property and each retrieved certificate $_.notafter 
property must be less than the current date which is the Get-Date cmdlet.

Fifth, it sorts the retrieved certificates by notafter property.

Sixth, ft selects the notafter, thumbprint, and subject properties in displaying the formatted
table with autosize and wrap for a more readable output.

Seventh, Pop-Location cmdlet reverts to the saved location from the Push-Location cmdlet earlier.

dir is an alias for Get-ChildItem cmdlet.
where is an alias for Where-Object cmdlet.
ft is an alias for Format-Table cmdlet.
#>

function Get-ExpiredCertificates
{
	Push-Location
	Set-Location Cert:
	dir .\CurrentUser -Recurse | where { !$_.psiscontainer -AND $_.notafter -lt (Get-Date)} | sort notafter | ft notafter, thumbprint, subject -AutoSize -Wrap
	Pop-Location
}