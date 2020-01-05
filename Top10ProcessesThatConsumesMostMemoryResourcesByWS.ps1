<#
.SYNOPSIS
Top10ProcessesThatConsumesMostMemoryResourcesByWS

.DESCRIPTION
This Powershell function displays the 10 processes that consumes most memory resources 
on the local system PC through its WS (Working Set). It chains many cmdlets altogether.
First, Get-Process cmdlet combines with Select-Object cmdlet where the -Property
parameter needed are ProcessName and WS. Whereas the Sort-Object sorts the highest WS
first through the -Descending parameter and the Select-Object parameter selects only 
the Top 10 Processes through the -First parameter.
#>

function Get-Top10ProcessesByWS
{
	Get-Process | Select-Object -Property ProcessName, WS | Sort-Object -Descending WS | Select-Object -First 10
}