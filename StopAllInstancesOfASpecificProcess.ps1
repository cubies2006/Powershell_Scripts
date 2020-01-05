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