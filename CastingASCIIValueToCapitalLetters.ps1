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