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