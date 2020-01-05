<#
.SYNOPSIS
ListOf5NewestEntriesFromApplicationLog

.DESCRIPTION
This Powershell script displays a list of the newest 5 entries from application log.

First, the Get-EventLog cmdlet gets all the event logs with filtering 
of -LogName parameter as application and the -Newest parameter to 5. 
The 5 resulting event application log objects is then pipelined to the 
Format-List cmdlet which only display the source, entrytype, and eventid 
via the -Property parameter in a list-formatted fashion.  
#>

Get-EventLog -LogName application -Newest 5 | Format-List -Property source, entrytype, eventid