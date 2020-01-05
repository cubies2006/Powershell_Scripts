<#
.SYNOPSIS
RenameAllFilesThroughForLoop

.DESCRIPTION
This Powershell function rename multiple files at once with the use of For Loop
and checks if the folder path exists.

First, [CmdletBinding()] decorator is stated which adds information to your 
parameter.

Second, Param() block is declared with $folderpath and $replacefilename variables that 
both accepts a string value. Both of their decorators specify that they are mandatory 
and both displays a help message when !? is entered to aid the user.

Third, the Test-Path cmdlet checks if $folderpath exists. 

If it does exist, it goes to the script block after the If statement. The gci alias gets
the files contained within $folderpath is assigned plus -Filter parameter is set with
whatever is contained in *.$($fileextension) and the -File parameter must also be included. 
It is assigned to $Files variable. In every iteration in the For Loop statement which 
requires $i to be less than $Files.count to be true, it first executes $num to be equal to 
$i plus 1. Then the Rename-Item cmdlet is executed which has 2 parameters. First is the -Path 
parameter where the $Files variable is used as an array counter to provide the full name 
property of a given path. Second is the -NewName paramater where $($replacefilename) 
subexpression is combined with $num and $fileextension. At the end of the For Loop, 
Write-Output cmdlet is displayed indicating that the renaming of all files with the
specified file extension has successfully completed.

Otherwise, it goes to the script block after the Else statement. The Write-Warning cmdlet
is triggered telling that the $folderpath does not exists and uses $env:computername to
declare the environment variable for the default computer name.

gci is an alias for Get-ChildItem cmdlet.
#>

function Rename-AllFilesThroughForLoop
{
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$True,
					HelpMessage = 'Enter the full folder path')]
		[String]$folderpath,
		[Parameter(Mandatory=$True,
					HelpMessage = 'Enter the file extension')]
		[String]$fileextension,
		[Parameter(Mandatory=$True,
					HelpMessage = 'Enter the replace filename')]
		[String]$replacefilename		
	)
	if (Test-Path $folderpath)
	{
		$Files = gci $folderpath -Filter *.$($fileextension) -File
		for ($i = 0; $i -lt $Files.count; $i++)
		{
			$num = $i + 1
			Rename-Item -Path $Files[$i].FullName -NewName "$($replacefilename)_$num.$fileextension"
		}
		Write-Output "Renaming each files with .$fileextension file extension to $($replacefilename) successfully completed"
	}
	else
	{
		Write-Warning "$folderpath does not exists on $env:computername!!!"
	}
}