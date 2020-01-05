<#
.SYNOPSIS
GroupingSimilarRunningProcesses

.DESCRIPTION
This Powershell script counts and groups all running processes on the local system PC.

It works by using the Get-Process cmdlet to get all running processes. The Sort-
Object sorts the resulting running process objects by name in property parameter.
It then groups the sorted process objects by name in property parameter and only
the group count is displayed without the grouping data through its -NoElement 
parameter. Finally, the Sort-Object once again sorts the group process objects in 
descending order through the -Descending parameter.
#>

Get-Process | Sort-Object name | Group-Object name -NoElement | Sort-Object Count -Descending