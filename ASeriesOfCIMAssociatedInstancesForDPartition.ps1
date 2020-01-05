<#
.SYNOPSIS
ASeriesOfCIMAssociatedInstancesForDPartition

.DESCRIPTION
This Powershell script displays many important system information related to the D: partition.

First, the $disk variable stores the Get-CimInstance cmdlet which retrieves all 
Win32_LogicalDisk WMI classes. Only d: must be selected via the -Filter parameter.

Second, the first Get-AssociatedInstance cmdlet is used to retrieve instances associated
with the Win32_LogicalDisk WMI class.

Third, the second Get-AssociatedInstance cmdlet retrieves only win32_directory WMI classes
with the -ResultClassName parameter.

Fourth, the third Get-AssociatedInstance cmdlet retrieves only win32_diskpartition WMI classes
with the -ResultClassName parameter.

Fifth, the fourth Get-AssociatedInstance cmdlet retrieves only win32_computersystem WMI classes
with the -ResultClassName parameter.

Sixth, the $dp variable stores the fifth Get-CimAssociatedInstance using previous $disk variable
which retrieves only win32_computersystem with the -ResultClassName parameter.

Seventh, the result of $dp variable is then pipeline to format table cmdlet which selects the
Device ID, Block Size, Number of BLicks, Size, and Starting Offset with Autosize parameter.
#>

$disk = Get-CimInstance Win32_LogicalDisk -Filter "name = 'd:'"
Get-CimAssociatedInstance $disk
Get-CimAssociatedInstance $disk -ResultClassName win32_directory
Get-CimAssociatedInstance $disk -ResultClassName win32_diskpartition
Get-CimAssociatedInstance $disk -ResultClassName win32_computersystem

$dp = Get-CimAssociatedInstance $disk -ResultClassName win32_diskpartition
$dp | ft DeviceID, BlockSize, NumberOfBLicks, Size, StartingOffSet -AutoSize