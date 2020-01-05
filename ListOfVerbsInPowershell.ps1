<#
.SYNOPSIS
ListOfVerbsInPowershell

.DESCRIPTION
This Powershell function lists all the verbs used in Windows Powershell. It also counts 
the number of verbs.

First, it uses Get-Command cmdlet with -CommandType parameter whose value is cmdlet.

Second, the returned cmdlet objects are then pipelined to Group-Object cmdlet with
the -Property parameter group to Verb.

Third, the returned group Verb cmdlet objects are then pipelined to the Sort-Object
cmdlet with -Property parameter set to count and -Descending parameter.
#>

function Show-PowershellVerbs
{
	Get-Command -CommandType cmdlet | Group-Object -Property Verb | Sort-Object -Property count -Descending
}