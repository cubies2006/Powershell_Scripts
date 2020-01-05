<#
.SYNOPSIS
CountFilesInAGivenPathByFileExtension

.DESCRIPTION
This Powershell function allows the user to enter a folder path and display all
counted files by file extension.
#>

function Measure-FilesInAGivenPathByExtension
{
	# Read-Host cmdlet accepts a folder path from user and stores in $directory variable.
	$directory = Read-Host "Enter a valid directory path"

	# Here the $directory folder path is checked if it exists with Test-Path cmdlet
	if (Test-Path $directory)
	{
		# All files specified from $directory are searched through Get-ChildItem cmdlet 
		# with -Recurse parameter to look in subdirectories and -File parameter to get 
		# only the files excluding folders. The resulting file objects are then pipelined
		# to Group-Object cmdlet which groups by Extension property. The grouped file
		# objects are stored in $files variable.
		$files = Get-ChildItem $directory -Recurse -File | Group-Object Extension
		
		# The $files variable is then pipelined to Sort-Object cmdlet which sorts by 
		# count property with -Descending parameter. The resulting sorted objects are
		# then pipelined to Select-Object cmdlet which gets only the Count, Name, and
		# Size whose custom property is defined in a hashtable which is represented by
		# @{}. Inside it, the Name is specified as Size while the Expression gets the
		# current Group object in the pipeline and using the Measure-Object cmdlet to
		# measure its Length property with -sum parameter. Finally, the sum property is
		# only needed, the whole expression is enclosed in parenthesis with dot(.) notation
		# to get the sum property of the currently pipelined grouped file object.
		$files | Sort-Object Count -Descending | Select-Object Count, Name, @{Name="Size"; Expression={($_.Group | Measure-Object Length -sum).sum}}
	}
	# The Write-Warning cmdlet is triggered if the $directory does not exist.
	else
	{
		Write-Warning "$directory does not exist."
	}
}
