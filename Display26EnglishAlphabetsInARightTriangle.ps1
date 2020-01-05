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