<#
.SYNOPSIS
5MostRecentErrorsFromApplicationLog

.DESCRIPTION
This Powershell script lists all 5 most recent error events that occured from the Application log.

First, it works with the Get-EventLog cmdlet with the -LogName parameter set as application,
the -EntryType parameter is error, and the -Newest parameter is 5.

Second, it then sorts the 5 resulting application error event log objects by message.

Third, it then groups the returned sorted logs by message.

Fourth, ft formats the result as a table with the -Autosize parameter reduces wasted space
between columns and produces a more readable output and the -Wrap parameter displays long 
error message wrapped in subsequent lines.

sort is an alias for Sort-Object cmdlet. 
group is an alias for Group-Object cmdlet.
ft is an alias for Format-Table cmdlet.
#>

Get-EventLog -LogName application -EntryType error -Newest 5 | sort message | group message | ft -Autosize -Wrap