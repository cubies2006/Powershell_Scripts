<#
.SYNOPSIS
ListOfAllMicrosoftPackages

.DESCRIPTION
This Powershell function finds specific information about packages from Microsoft publisher.

First, the Get-AppxPackage cmdlet returns all packages from various publishers.

Second, the Select-Object cmdlet choose only the Name, Version, and Publisher properties 
from the returned AppxPackage objects. 

Third, the Where-Object cmdlet is used to filter resulting packages created by Microsoft by 
matching the Publisher with Microsoft via the -Match parameter. 

Fourth, Sort-Object cmdlet sorrs the names of the packages in the default ascending list order. 

Fifth, the Format-Table cmdlet formats the result in a table. The -Autosize paramater causes 
Format-Table cmdlet to wait until all data is available, and then the space between columns 
reduces to fit the actual size of the data contained in the columns. The -Wrap parameter 
displays the name of the publisher wrapped in subsequent lines.
#>

function Read-MicrosoftPackages
{
	Get-AppxPackage | Select-Object Name, Version, Publisher | Where-Object Publisher -Match Microsoft | Sort-Object Name | Format-Table -Autosize -Wrap
}