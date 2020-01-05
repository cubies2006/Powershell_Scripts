<#
.SYNOPSIS
DriverQueryExternalUtility

.DESCRIPTION
This Powershell function uses the external utility DriverQuery.exe
and then uses Powershell cmdlets to lists the 5 most recent drivers 
based on its Link Date and whose Driver Type is not match with Kernel.

First, driverquery /fo csv is run which formats the output of driverquery 
to be converted as csv rather than plain text. The csv is then pipelined
to ConvertFrom-CSV cmdlet which transforms into a Powershell object and
stores it as $d variable.

Second, the $d variable which contains the converted Powershell object 
can be further manipulated and pipelined to other Powershell cmdlets. 
It is then pipelined to Where cmdlet whose Drive Type property must not 
match with Kernel. And the Link Date property can be sorted in descending 
order by using Sort cmdlet and a hashtable denoted by @{} where the said 
Link Date is typed as [datetime]. The Select cmdlet choose the first 5 
drivers with only Display Name, Driver Type, and Link Date.  

Where is an alias for Where-Object.
Sort is an alias for Sort-Object.
Select is an alias for Select-Object.
#>

function Get-DriverQuery
{
	$d = driverquery /fo csv | ConvertFrom-CSV

	$d | Where {$_."Driver Type" -notmatch "Kernel"} |
	Sort @{expression = {$_."Link Date" -as [datetime]}} -desc |
	Select -First 5 -Property "Display Name", "Driver Type", "Link Date"
}