<#
.SYNOPSIS
Get-NBTName

.DESCRIPTION
This Powershell function uses a nbtstat external utility to extract its contents
and display as a Powershell custom object.
#>

function Get-NBTName
{
	#requires -version 3.0
	# nbtstat /n lists NetBIOS names. It is then pipelined to Select-String cmdlet
	# which finds strings that start with "<". It is further pipelined to where
	# to not match with __MSBROWSE__. This command should leave only the lines that 
	# have a <> in the text and store it as $data variable.
	$data = nbtstat /n | Select-String "<" | where {$_ -notmatch "__MSBROWSE__"}

	# From $data, take each line and trim it up. Each line is then saved to $lines 
	# variable.
	$lines = $data | foreach { $_.Line.Trim()}

	# Split each line at the space into an array and add each element to a hash table
	$lines | foreach {
		$temp = $_ -split "\s+"
		# Create an object from the hash table
		[PSCustomObject]@{
			Name = $temp[0]
			NbtCode = $temp[1]
			Type = $temp[2]
			Status = $temp[3]
		}
	}
}