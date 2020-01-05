<#
.SYNOPSIS
RenameMultipleFilesAtOnce

.DESCRIPTION
This Powershell function rename multiple files at once and checks if the folder path exists
and if the original and the replace strings are different.

First, [CmdletBinding()] decorator is stated which adds information to your 
parameter.

Second, Param() block is declared with $folderpath, $originalstring and $replacestring 
variables that all accepts a string value. All of their decorators specify that they are 
mandatory and all displays a help message when !? is entered to aid the user.

Third, the Test-Path cmdlet checks if $folderpath exists. 

If it does exist, it goes to the script block after the If statement. A nested If ... Else
statement further checks if the contents of both $originalstring and $replacestring are 
different with -cne (case-sensitive not equal to) operator. If yes, it goes within the script 
block after the innermost If statement. The Dir alias is use to locate $folderpath. Then 
Rename-Item cmdlet whose -NewName paramater enters a Script Block where $_ is the automatic 
variable which represents each item returned to change its name property from $originalstring to 
$replacestring through the -Replace paramater. And Write-Output cmdlet displays that the renaming 
files were successful. If no, it goes within the script block after the innermost Else statement.
A Write-Watning cmdlet is displayed telling that both strings must be different.

Otherwise, it goes to the script block after the Else statement. The Write-Warning cmdlet
is triggered telling that the $folderpath does not exists and uses $env:computername to
declare the environment variable for the default computer name.

Dir is an alias for Get-ChildItem cmdlet. 
#>

function Rename-MultipleFiles
{
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$True,
					HelpMessage = 'Enter the full folder path')]
		[String]$folderpath,
		[Parameter(Mandatory=$True,
					HelpMessage = 'Enter the original string')]
		[String]$originalstring,
		[Parameter(Mandatory=$True,
					HelpMessage = 'Enter the replace string')]
		[String]$replacestring		
	)
	if (Test-Path $folderpath)
	{
		if ($originalstring -cne $replacestring)
		{		
			Dir $folderpath | Rename-Item -NewName {$_.name -Replace $originalstring, $replacestring}
			Write-Output "Renaming multiple files successfully completed"
		}
		else
		{
			Write-Warning "Both strings must be different."
		}
	}
	else
	{
		Write-Warning "$folderpath does not exists on $env:computername!!!"
	}
}