# CUBIESModule.psm1

# 1. Place all existing Powershell functions here to autoload it either in Powershell Console or Powershell ISE.
# 2. Run the ImportCUBIESModule.ps1 script located at D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\ 
# which will autoload the CUBIESModule in either Powershell Console or Powershell ISE on the System PC.
# 3. To check for list of approved verbs, simply run Get-Verb cmdlet in either Powershell Console or Powershell ISE.

<#
.SYNOPSIS
DriverQueryExternalUtility

.DESCRIPTION
This Powershell function uses the external utility DriverQuery.exe
and then uses Powershell cmdlets to lists the 5 most recent drivers 
based on its Link Date and whose Driver Type is not match with Kernel.

First, driverquery /fo csv is run which formats the output of driverquery 
to be converted as csv rather than plain text. The csv is then pipelined
to ConvertFrom-CSV cmdlet which transforms into a Powershell object and
stores it as $d variable.

Second, the $d variable which contains the converted Powershell object 
can be further manipulated and pipelined to other Powershell cmdlets. 
It is then pipelined to Where cmdlet whose Drive Type property must not 
match with Kernel. And the Link Date property can be sorted in descending 
order by using Sort cmdlet and a hashtable denoted by @{} where the said 
Link Date is typed as [datetime]. The Select cmdlet choose the first 5 
drivers with only Display Name, Driver Type, and Link Date.  

Where is an alias for Where-Object.
Sort is an alias for Sort-Object.
Select is an alias for Select-Object.
#>

function Get-DriverQuery
{
	$d = driverquery /fo csv | ConvertFrom-CSV
	$d | Where {$_."Driver Type" -notmatch "Kernel"} |
	Sort @{expression = {$_."Link Date" -as [datetime]}} -desc |
	Select -First 5 -Property "Display Name", "Driver Type", "Link Date"
}

<#
.SYNOPSIS
FactorialOfAGivenNumber

.DESCRIPTION
This Powershell function allows the user to enter a numeric value and obtain its Factorial.
#>

function Get-Factorial
{
	try
	{
		$input = Read-Host "Enter a number for Factorial"		
		if ([int]$input -is[ValueType] -or [long]$input -is[ValueType])
		{
			if ([int]$input -lt 0 -or [long]$input -lt 0)
			{
				Write-Warning "$input is an INVALID INPUT!!!"
			}
			elseif ([int]$input -eq 0 -or [long]$input -eq 0)
			{
				$factorial = 1
				Write-Host "The Factorial of $input is $factorial" -ForegroundColor Cyan
			}
			else
			{
				$factorial = Invoke-Expression(1..$input -join '*')
				Write-Host "The Factorial of $input is $factorial" -ForegroundColor Cyan
			}
		}
	}
	catch
	{
		Write-Warning "$input cannot perform Factorial!!!"
	}
}

<#
.SYNOPSIS
FindingAllExpiredCertificates

.DESCRIPTION
This Powershell function retrieves the expiration dates, the thumbprints, and the subjects
of all expired certificates.

First, Push-Location cmdlet saves the current location.

Second, Set-Location cmdlet redirects from the current path to Cert:\ drive.

Third, dir alias retrieves every certificate in the currentuser store beginning at the root 
level through its -Recurse parameter.

Fourth, the where alias contains a script block which states that the certificate store must 
be filtered out through !$_.psicontainer property and each retrieved certificate $_.notafter 
property must be less than the current date which is the Get-Date cmdlet.

Fifth, it sorts the retrieved certificates by notafter property.

Sixth, ft selects the notafter, thumbprint, and subject properties in displaying the formatted
table with autosize and wrap for a more readable output.

Seventh, Pop-Location cmdlet reverts to the saved location from the Push-Location cmdlet earlier.

dir is an alias for Get-ChildItem cmdlet.
where is an alias for Where-Object cmdlet.
ft is an alias for Format-Table cmdlet.
#>

function Get-ExpiredCertificates
{
	Push-Location
	Set-Location Cert:
	dir .\CurrentUser -Recurse | where { !$_.psiscontainer -AND $_.notafter -lt (Get-Date)} | sort notafter | ft notafter, thumbprint, subject -AutoSize -Wrap
	Pop-Location
}

<#
.SYNOPSIS
Get-NBTName

.DESCRIPTION
This Powershell function uses a nbtstat external utility to extract its contents
and display as a Powershell custom object.
#>

function Get-NBTName
{
	$data = nbtstat /n | Select-String "<" | where {$_ -notmatch "__MSBROWSE__"}
	$lines = $data | foreach { $_.Line.Trim()}
	$lines | foreach {
		$temp = $_ -split "\s+"
		[PSCustomObject]@{
			Name = $temp[0]
			NbtCode = $temp[1]
			Type = $temp[2]
			Status = $temp[3]
		}
	}
}

<#
.SYNOPSIS
Top10ProcessesThatConsumesMostMemoryResourcesByWS

.DESCRIPTION
This Powershell function displays the 10 processes that consumes most memory resources 
on the local system PC through its WS (Working Set). It chains many cmdlets altogether.
First, Get-Process cmdlet combines with Select-Object cmdlet where the -Property
parameter needed are ProcessName and WS. Whereas the Sort-Object sorts the highest WS
first through the -Descending parameter and the Select-Object parameter selects only 
the Top 10 Processes through the -First parameter.
#>

function Get-Top10ProcessesByWS
{
	Get-Process | Select-Object -Property ProcessName, WS | Sort-Object -Descending WS | Select-Object -First 10
}

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
	whoami /groups /fo list | 
	Select -Skip 4 | 
	? {$_} |
	% -Begin {$i = 0; $hash = @{}} -Process {
		if ($i -ge 4)
		{
			[PSCustomObject]$hash
			$hash.Clear()
			$i = 0
		}
		else
		{
			$data = $_ -split ":"
			$hash.Add($data[0].Replace(" ", ""), $data[1].Trim())
			$i++
		}
	}
}

<#
.SYNOPSIS
UpperLimitInFibonacciSequence

.DESCRIPTION
This Powershell function allows the user to enter an upper limit of a Fibonacci Sequence.
The complete sequence is then displayed up until it is less than the specified upper limit.
#>

function Get-UpperLimitFibonacciSequence
{
	try
	{
		$upper = Read-Host "Enter an upper limit for Fibonacci Sequence"		
		if ([int]$upper -is[ValueType] -or [long]$upper -is[ValueType])
		{
			if ([int]$upper -le 0 -or [long]$upper -le 0)
			{
				Write-Warning "$upper is an INVALID INPUT!!!"
			}
			else
			{
				$($c = $p = 1; Write-Host $c; while ($c -le $upper) {Write-Host $c; $c, $p = ($c + $p), $c})
			}
		}
	}
	catch
	{
		Write-Warning "$upper cannot be set as the Upper Limit in Fibonacci Sequence!!!"
	}
}

<#
.SYNOPSIS
CountFilesInAGivenPathByFileExtension

.DESCRIPTION
This Powershell function allows the user to enter a folder path and display all
counted files by file extension.
#>

function Measure-FilesInAGivenPathByExtension
{
	$directory = Read-Host "Enter a valid directory path"
	if (Test-Path $directory)
	{
		$files = Get-ChildItem $directory -Recurse -File | Group-Object Extension		
		$files | Sort-Object Count -Descending | Select-Object Count, Name, @{Name="Size"; Expression={($_.Group | Measure-Object Length -sum).sum}}
	}
	else
	{
		Write-Warning "$directory does not exist."
	}
}

<#
.SYNOPSIS
RemovePowershellPersistentConsoleHostHistory

.DESCRIPTION
This Powershell function removes the ConsoleHost_history.txt, which stores all previously
typed commands in the Windows Powershell console, located at C:\Users\Ronald Ong Dee\
AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ folder path. It will take effect 
when Powershell is closed and eventually restarted.

This one-line command uses Remove-Item cmdlet to remove the HistorySavePath property
which points to the console host history text file from Get-PSReadlineOption object 
which returns the current state of the settings.
#>

function Remove-PowershellConsoleHostHistory
{
	Remove-Item (Get-PSReadlineOption).HistorySavePath
}

<#
.SYNOPSIS
CastingASCIIValueToCapitalLetters

.DESCRIPTION
This Powershell function converts ASCII Value to capital letters in
the English alphabet where it mainly involves the use of array, 
do ... while looping statement, and casting data type.

First, $i variable is set to 0 which will serve as the loop counter.

Second, $array variable contains 26 values in the range of 65 to 91.

Third, the do ... while looping statement contains a script block 
where the $array[$i] is cast from the default integer to character 
displaying a letter instead of numeric value. $i++ increments the 
$i variable. At the end of the loop statement, a condition evaluates
the value of i if it is less than 26. If yes, the loop continues. 
Otherwise, the loop ends after its 26th pass. 
#>

function Show-ASCIItoCapitalLetters
{
	$i = 0
	$array = 65..91
	do {
		[char]$array[$i]
		$i++
	} while ($i -lt 26)
}

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

<#
.SYNOPSIS
Display26EnglishAlphabetsInARightTriangle

.DESCRIPTION
This Powershell function displays all 26 English Alphabet in a right triangle format
based on their numberic equivalent.

The 1..26 is in array range operator. It is then pipelined to the ForEach-Object
cmdlet where every number object is evaluated in a Script Block enclosed in {}. 
Inside (), 'A' is cast twice as character then to integer while $_ automatic
variable of the current number object is subtracted to 1.
The 2 numeric values inside () are eventually added and cast twice as character
then to string. Finally, the casted string object is multiplied to the $_ automatic
variable so that the string will appear as many times as $_ indicated.
#>

function Show-EnglishAlphabetsInRightTriangle
{
	1..26 | ForEach-Object {[string][char]([int][char]'A' + $_ - 1) * $_}
}

<#
.SYNOPSIS
GenerateTextFileForAllServices

.DESCRIPTION
This Powershell function obtains all the service information and store it as .txt file.

First, the Get-Service cmdlet acquires all service objects from the local system PC.

Second, the resulting service objects are pipelined to the Format-Table cmdlet which 
selects all properties via the * in -Property parameter with -Force and -Auto parameters.

Third, the table-formatted service objects are then pipelined to Out-File cmdlet which 
stores it as a .txt file which will make it more readable. The complete path along with 
the name of .txt file must be specified at the -FilePath parameter. To ensure that 
Unicode characters are properly recorded, set the -Encoding parameter to UTF8. To ensure 
that each row of data has enough space to write, set the -Width parameter to 500.

Fourth, the Invoke-Item cmdlet opens the newly created .txt file.
#>

function Show-GeneratedServiceTextFile
{
	Get-Service | Format-Table -Property * -Force -Auto | Out-File -FilePath D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\GeneratedAllServiceObjects.txt -Encoding UTF8 -Width 500
	Invoke-Item D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\GeneratedAllServiceObjects.txt
}

<#
.SYNOPSIS
GrandLottoSimulation

.DESCRIPTION
This Powershell function simulates the 6 winning numbers in Grand Lotto 6/58.

It uses Get-Random cmdlet where array numbers 1 to 58 are to be selected 
randomly via -InputObject parameter and the -Count parameter chooses only 6.
#>

function Show-GrandLotto
{
	Get-Random -InputObject(1..58) -Count 6
}

<#
.SYNOPSIS
ListOfAllMicrosoftPackages

.DESCRIPTION
This Powershell function finds specific information about packages from Microsoft publisher.

First, the Get-AppxPackage cmdlet returns all packages from various publishers.

Second, the Select-Object cmdlet choose only the Name, Version, and Publisher properties 
from the returned AppxPackage objects. 

Third, the Where-Object cmdlet is used to filter resulting packages created by Microsoft by 
matching the Publisher with Microsoft via the -Match parameter. 

Fourth, Sort-Object cmdlet sorrs the names of the packages in the default ascending list order. 

Fifth, the Format-Table cmdlet formats the result in a table. The -Autosize paramater causes 
Format-Table cmdlet to wait until all data is available, and then the space between columns 
reduces to fit the actual size of the data contained in the columns. The -Wrap parameter 
displays the name of the publisher wrapped in subsequent lines.
#>

function Show-MicrosoftPackages
{
	Get-AppxPackage | Select-Object Name, Version, Publisher | Where-Object Publisher -Match Microsoft | Sort-Object Name | Format-Table -Autosize -Wrap
}

<#
.SYNOPSIS
RemoteComputerInventory

.DESCRIPTION
This Powershell function checks the connectivity of all computers in a given network
and displays important specification (Computer, Manufacturer, Model, Processor, System
Type, Operating System, OS Version, OS Build Version, Serial Number, IP Address, MAC
Address, Last User, Last User Login, C: Capacity, C: Freespace, D: Capacity, D: Freespace,
Total Memory, and Last Boot) on each of them in a .CSV file. This is very useful in
getting system information of multiple PCs across a given network.
#>

function Show-RemoteComputerInventoryInCSV
{
	$testcomputers = Get-Content -Path 'D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\ListOfComputers.txt'
	$exportLocation = 'D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\RemoteComputerInventory.csv'	
	Clear-Content -path 'D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\LivePCs.txt'
	Clear-Content -path 'D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\DeadPCs.txt'
			
	foreach ($computer in $testcomputers)
	{
		if (Test-Connection -Computername $computer -Quiet -Count 2)
		{
			Add-Content -value $computer -path 'D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\LivePCs.txt'
		}
		else
		{
			Add-Content -value $computer -path 'D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\DeadPCs.txt'
		}
	}
	
	$computers = Get-Content -Path 'D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\LivePCs.txt'

	foreach ($computer in $computers)
	{
		$Bios = Get-WmiObject win32_Bios -Computername $computer
		$Hardware = Get-WmiObject win32_ComputerSystem -Computername $computer
		$Sysbuild = Get-WmiObject win32_WmiSetting -Computername $computer
		$OS = Get-WmiObject win32_OperatingSystem -Computername $computer
		$Networks = Get-WmiObject win32_NetworkAdapterConfiguration -Computername $computer | Where-Object {$_.IPEnabled}
		$DriveC = Get-WmiObject win32_Volume -Computername $computer -Filter 'drivetype = 3' |
		Select-Object PSComputerName, driveletter, 
		@{label = 'GBCapacity'; expression = {'{0:N2}' -f($_.capacity/1GB)}},
		@{label = 'GBFreeSpace'; expression = {'{0:N2}' -f($_.freespace/1GB)}} | Where-Object {$_.driveletter -match 'C:'}	
		$DriveD = Get-WmiObject win32_Volume -Computername $computer -Filter 'drivetype = 3' |
		Select-Object PSComputerName, driveletter,
		@{label = 'GBCapacity'; expression = {'{0:N2}' -f($_.capacity/1GB)}}, 
		@{label = 'GBFreeSpace'; expression = {'{0:N2}' -f($_.freespace/1GB)}} | Where-Object {$_.driveletter -match 'D:'}
		$CPU = Get-WmiObject win32_Processor -Computername $computer
		$Username = Get-ChildItem "\\$computer\c$\Users" | Sort-Object LastWriteTime -Descending | 
		Select-Object Name, LastWriteTime | Where-Object {$_.name -eq "Ronald Ong Dee"}
		$TotalMemory = [math]::round($Hardware.TotalPhysicalMemory/1024/1024/1024, 2)
		$LastBoot = $OS.ConvertToDateTime($OS.LastBootUpTime)
		$IPAddress = $Networks.IpAddress[0]
		$MACAddress = $Networks.MACAddress[0]
		$SystemBios = $Bios.SerialNumber
		
		$specs = [ordered]@{
			'ComputerName' = $computer.ToUpper()
			'Manufacturer' = $Hardware.Manufacturer
			'Model' = $Hardware.Model
			'Processor Type' = $CPU.Name
			'System Type' = $Hardware.SystemType
			'Operating System' = $OS.Caption
			'OS Version' = $OS.Version
			'OS Build Version' = $Sysbuild.BuildVersion
			'Serial Number' = $SystemBios
			'IP Address' = $IPAddress
			'MAC Address' = $MACAddress
			'Last User' = $Username.Name
			'User Last Login' = $Username.LastWriteTime
			'Drive C:\ Capacity (GB)' = $DriveC.GBCapacity
			'Drive C:\ Free Space (GB)' = $DriveC.GBFreeSpace
			'Drive D:\ Capacity (GB)' = $DriveD.GBCapacity
			'Drive D:\ Free Space (GB)' = $DriveD.GBFreeSpace
			'Total Memory (GB)' = $TotalMemory
			'Last Boot' = $LastBoot
		}
		
		$outputObj = New-Object -Type PSObject -Property $specs 
		$outputObj | Export-CSV -Path $exportLocation -Append -NoTypeInformation
	}
	Invoke-Item $exportLocation
}

<#
.SYNOPSIS
StopAllInstancesOfASpecificProcess

.DESCRIPTION
This Powershell function allows the user to enter a specific process name 
and stop all instances of it which is very useful when a certain process 
hangs up. It runs in 2 ways either by parameter input or by pipeline input.

First, [CmdletBinding()] decorator is stated which adds information to your 
parameter.

Second, Param() block is declared with $process variable has String data 
type enclosed in [] to signify that it accepts multiple String objects. 
Its decorators specify that its mandatory, can accept value from pipeline, 
and displays a help message when !? is entered to aid the user.

Second, Process{} Block is run based on the number of string objects either
coming from the parameter input or from the pipeline. Inside the Block, it 
contains the Get-Process cmdlet with the -Name parameter uses $process. The
selected process objects are then piped to Stop-Process cmdlet which stops 
all instances of the specified process objects while the -PassThru parameter 
passes the process object along the pipeline. Finally it is pipelined to the 
ForEach-Object cmdlet uses a Script Block that displays a message where $_ 
automatic variable refers to the current object on the pipeline and select 
the name and process ID of the process that was stopped.

.PARAMETER process
Accepts one or more process names.

.EXAMPLE
This example uses parameter input.
Stop-MultipleProcess -process "javaw", "notepad++"

.EXAMPLE
This example uses pipeline input.
"javaw", "notepad++" | Stop-MultipleProcess

.EXAMPLE
This example uses the command-line prompt.
cmdlet Stop-MultipleProcess at command pipeline position 1
Supply values for the following parameters:
(Type !? for Help.)
process[0]: bittorrent
process[1]: explorer
process[2]:
BitTorrent with process ID 6388 was stopped.
explorer with process ID 3092 was stopped.
#>

Function Stop-MultipleProcess
{
	[CmdletBinding()]
	Param(
		[Parameter(Mandatory=$True,
					ValueFromPipeline=$True,
					HelpMessage = 'Enter a specific process to be stopped')]
		[String[]]$process
	)
    Process
    {
	    Get-Process -Name $process | 
	    Stop-Process -PassThru |
	    ForEach-Object {$_.Name + ' with process ID ' + $_.ID + ' was stopped.'}
	}
}