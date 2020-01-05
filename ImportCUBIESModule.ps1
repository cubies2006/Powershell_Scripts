<#
.SYNOPSIS
Import CUBIESModule

.DESCRIPTION
This Powershell script imports the CUBIESModule.

First, it declares the source module path and stores it in a $SourcePath variable. Take note that the filename of .psm1
must be exactly the same with the module folder which is both CUBIESModule.

Second, By default, $env:PSModulePath -split ";" shows three of the autosearched locations for Powershell modules which 
allows autoloading. Those locations are defined in the system-wide PSModulePath environment variable. The CUBIESModule
should go in the Documents location which is the first element, not in the System32 location. The second element which is
System32 is generally reserved for modules distributed by Microsoft. Windows security will also make it more difficult to 
change modules in the System32 location. The third element which is the Program Files location is used for modules one need 
for configurations managed in Desired State Configuration.

Third, only the first $path element $path[0] is needed, concatenate it with the module name which is CUBIESModule, and store 
it in $ModulePath variable.

Fourth, an If-Else Statement is used to check if $ModulePath does not exists with Test-Path cmdlet.
 
If it does not exists, $SourcePath is imported with Import-Module cmdlet. It will then create a new folder whose name is 
$ModulePath through New-Item cmdlet with -ItemType parameter set to Directory. Then Copy-Item cmdlet duplicates the $SourcePath 
to the -Destination parameter set to $ModulePath and -Force switch parameter is enabled. 

Otherwise, Remove-Module cmdlet is triggered removing the first element $path[0] with -Recurse switch enabled.
#>

$SourcePath = "D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\CUBIESModule.psm1"

$path = $env:PSModulePath –split “;”

$ModulePath = $path[0] + “\CUBIESModule”

if (!(Test-Path $ModulePath))
{
	Import-Module $SourcePath
	New-Item $ModulePath –ItemType Directory
	Copy-Item $SourcePath –Destination $ModulePath -Force
}
else
{
	Remove-Item $path[0] -Recurse
}
