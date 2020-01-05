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