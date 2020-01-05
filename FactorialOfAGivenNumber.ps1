<#
.SYNOPSIS
FactorialOfAGivenNumber

.DESCRIPTION
This Powershell function allows the user to enter a numeric value and obtain its Factorial.
#>

function Get-Factorial
{
	# The Try ... Catch Statement is use for error checking.
	try
	{
		# Read-Host cmdlet accepts only numeric value from user and stores in $input variable.
		$input = Read-Host "Enter a number for Factorial"
		
		# The Outer If Statement evaluates $input is cast as either [int] or [long] is equal to [ValueType].
		# If true, it enters the Inner If ... ElseIf ... Else Statement for further evaluation. Otherwise, 
		# it catches the error and jump to Catch Statement where Write-Warning cmdlet triggers a warning.
		if ([int]$input -is[ValueType] -or [long]$input -is[ValueType])
		{
			# In the Inner If ... ElseIf ... Else Statement where $input is cast as either [int] or [long] is 
			# less than 0, the Write-Warning cmdlet is triggered displaying an error message.
			if ([int]$input -lt 0 -or [long]$input -lt 0)
			{
				Write-Warning "$input is an INVALID INPUT!!!"
			}
			# Else if $input is cast as either [int] or [long] is equal to 0, $factorial is set to 1 and displays 
			# a confirmation via Write-Host cmdlet with -ForegroundColor parameter set to Cyan. 
			elseif ([int]$input -eq 0 -or [long]$input -eq 0)
			{
				$factorial = 1
				Write-Host "The Factorial of $input is $factorial" -ForegroundColor Cyan
			}
			# Otherwise, it enters the Invoke-Expression cmdlet evaluates the array range from 1 to $input and 
			# combine it with '*' through -join parameter effectively multiplying the array. It then displays a 
			# confirmation via Write-Host cmdlet with -ForegroundColor parameter set to Cyan.
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