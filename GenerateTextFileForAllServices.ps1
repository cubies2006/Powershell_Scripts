<#
.SYNOPSIS
GenerateTextFileForAllServices

.DESCRIPTION
This Powershell function obtains all the service information and store it as .txt file.

First, the Get-Service cmdlet acquires all service objects from the local system PC.

Second, the resulting service objects are pipelined to the Format-Table cmdlet which 
selects all properties via the * in -Property parameter with -Force and -Auto parameters.

Third, the table-formatted service objects are then pipelined to Out-File cmdlet which 
stores it as a .txt file which will make it more readable. The complete path along with 
the name of .txt file must be specified at the -FilePath parameter. To ensure that 
Unicode characters are properly recorded, set the -Encoding parameter to UTF8. To ensure 
that each row of data has enough space to write, set the -Width parameter to 500.

Fourth, the Invoke-Item cmdlet opens the newly created .txt file.
#>

function Show-GeneratedServiceTextFile
{
	Get-Service | Format-Table -Property * -Force -Auto | Out-File -FilePath D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\GeneratedAllServiceObjects.txt -Encoding UTF8 -Width 500
	Invoke-Item D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\GeneratedAllServiceObjects.txt
}