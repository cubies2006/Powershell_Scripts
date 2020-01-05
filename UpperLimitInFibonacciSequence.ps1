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
		# Read-Host cmdlet accepts only numeric value from user and stores in $upper variable.
		$upper = Read-Host "Enter an upper limit for Fibonacci Sequence"
		
		# Checks if $upper variable which is either integer or long must be of ValueType. 
		# If not, it goes to the catch statement where a warning message will be displayed 
		# through Write-Warning cmdlet.
		if ([int]$upper -is[ValueType] -or [long]$upper -is[ValueType])
		{
			# $upper variable which is either integer or long value must not be less than or equal to 0.
			if ([int]$upper -le 0 -or [long]$upper -le 0)
			{
				Write-Warning "$upper is an INVALID INPUT!!!"
			}
			else
			{
				# $() is a subexpression that combines multiple substatements in one line.
				# In the first substatement, multiple assignment is assigned where both $c and $p is equal to 1.
				# In the second substatement, Write-Host cmdlet displays the value of $c which is 1.
				# In the third substatement, While conditions if $c is less than or equal to $upper. 
				# If yes, the 2 inner statements enclosed in {} within Script Block is executed. 
				# Otherwise, it is skipped and the script ends execution.
				# Inner 1 = Write-Host cmdlet displays the value of $c which is initially 1 but will obtain
				# other values as long as the While condition is true.
				# Inner 2 = The values of $c and $p are swapped to ($c + $p) and $c respectively as long as
				# the While condition is true.
				$($c = $p = 1; Write-Host $c; while ($c -le $upper) {Write-Host $c; $c, $p = ($c + $p), $c})
			}
		}
	}
	catch
	{
		Write-Warning "$upper cannot be set as the Upper Limit in Fibonacci Sequence!!!"
	}
}