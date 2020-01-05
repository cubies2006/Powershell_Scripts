<#
.SYNOPSIS
GroupingStoppedAndRunningServices

.DESCRIPTION
This Powershell script counts and groups all stopped and running services
on the local system PC.

It works by using the Get-Service cmdlet. The resulting service objects 
is then pipelined to sort by status. Finally, the sorted service objects
is then again pipelined to group by status.

sort is an alias for Sort-Object cmdlet.
group is an alias for Group-Object cmdlet.
#>

Get-Service | sort status | group status