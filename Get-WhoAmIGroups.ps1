<#
.SYNOPSIS
Get-WhoAmIGroups

.DESCRIPTION
This Powershell function uses the WhoAmI external utility which intiallly
displays in list format and using various Powershell techniques to turn 
it to a Powershell object. 
#>

function Get-WhoAmIGroups
{
	#Requires -version 3.0

	# First, it uses WhoAmI external utility can be used to get the user anme 
	# and group information along with the respective security identifiers
	# (SID), claims, privileges, and logon identifier (logon ID) for the 
	# current user. It uses /groups parameter which displays group membership
	# for current user along with SID. It also uses /fo list parameter which
	# specifies the output in list format.
	whoami /groups /fo list | 

	# It is then pipelined to Select with -Skip 4 parameter to skip the first 
	# 4 lines of the GROUP INFORMATION header.
	Select -Skip 4 | 

	# It is further pipelined to ? {} retrieves all the remaining lines with $_ 
	# represents current object in the pipeline of WhoAmI /Groups external utility.
	# ? is an alias for Where-Object cmdlet.
	? {$_} |

	# It is again further pipelined to % with -Begin script block parameter which 
	# intializes $i = 0 and $hash = @{}, the -Process script block paramater which 
	# keep track of the number of lines that have been processed.
	# % is an alias for ForEach-Object cmdlet. 
	% -Begin {$i = 0; $hash = @{}} -Process {
		# When $i is equal to 4, a hash table named $hash is created with [PSCustomObject]
		# type, clears any existing $hash entries with Clear() property, and resets $i 
		# back to 0.
		if ($i -ge 4)
		{
			[PSCustomObject]$hash
			$hash.Clear()
			$i = 0
		}
		# If $i is less than 4, split each line into an array using : as the
		# delimiter. The first element of the array $data[0] is added as the key 
		# to $hash hash table, replacing any spaces with nothing. The second array
		# element $data[1] is added as the value, trimmed to extra leading or 
		# trailing spaces. The two array elements $data[0] and $data[1] are then added
		# to $hash hash table with Add() method. $i is incremented by 1. This process 
		# repeats until $i equals 4, at which point a new object is written to the pipeline.
		else
		{
			$data = $_ -split ":"
			$hash.Add($data[0].Replace(" ", ""), $data[1].Trim())
			$i++
		}
	}
}