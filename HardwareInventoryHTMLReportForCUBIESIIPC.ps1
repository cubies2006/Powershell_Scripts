<#
.SYNOPSIS
HardwareInventoryHTMLReportForCUBIESIIPC

.DESCRIPTION
This Powershell script generates HTML Report of the Hardware Inventory
for CUBIES II PC as per Computer System, Logical Disk, and Network
Adapter classes from WMI Object.
#>


$computername = 'CUBIESII'

# Get selected properties from Computer System class with the use of hashtables
$output = Get-WmiObject -class Win32_ComputerSystem -Computer $computername |
Select-Object -Property Manufacturer, Model, 
@{name = 'Memory(GB)'; expression = {$_.TotalPhysicalMemory / 1GB -as [int]}},
@{name = 'Architecture'; expression = {$_.SystemType}},
@{name = 'Processors'; expression = {$_.NumberOfProcessors}} |

# ConvertTo-HTML changes the selected WMI objects into HTML data with -Fragments
# parameter to construct a multisection HTML page, -As LIST parameter changes the 
# output from the default table form into a list, and -PreContent parameter adds 
# textual content before the main HTML table or list constructed by the cmdlet.
# The resulting HTML fragment is then pipelined to Out-String
ConvertTo-HTML -Fragment -As LIST -PreContent "<h2>Computer Hardware:</h2>" | Out-String

# Get selected properties from Logical Disk class with the use of hashtables
$output += Get-WmiObject -class Win32_LogicalDisk -Computer $computername |
Select-Object -Property @{name = 'DriveLetter'; expression = {$_.DeviceID}},
@{name = 'Size(GB)'; expression = {$_.Size / 1GB -as [int]}},
@{name = 'FreeSpace(GB)'; expression = {$_.FreeSpace / 1GB -as [int]}} |
ConvertTo-HTML -Fragment -PreContent "<h2>Disks:</h2>" | Out-String

# Get selected properties from Network Adapter class with the use of hashtables
$output += Get-WmiObject -class Win32_NetworkAdapter -Computer $computername |
Where {$_.PhysicalAdapter} |
Select-Object -Property MACAddress, AdapterType, DeviceID, Name |
ConvertTo-HTML -Fragment -PreContent "<h2>Physical Network Adapters:</h2>" | Out-String

# The $head variable contains the embedded CSS stylesheet without using -CssUri parameter
$head = @'
<style>
body { 
	background-color: #dec04e;
	font-family: Tahoma;
	font-size: 12pt; 
}
td, th { 
	border: 1px solid black;
	border-collapse: collapse;
}
th { 
	color: white;
	background-color: black; 
}
table, tr, td, th { 
	padding: 2px; 
	margin: 0px 
}
table { 
	margin-left:50px; 
}
</style>
'@

# The final ConvertTo-HTML cmdlet with -Head parameter that uses $head variable which 
# specifies the HTML-formatted text to be included in the <HEAD> section of the final HTML,
# -PostContent parameter uses $output variable which adds textual content after the main 
# HTML table or list constructed by the cmdlet, and the -Body parameter displays the
# header before the contents of -PostContent parameter.
ConvertTo-HTML -head $head -PostContent $output -Body "<h1>Hardware Inventory for $ComputerName PC</h1>" | 
# The resulting HTML object is pipelined to Out-File cmdlet with -Filepath parameter which 
# specifies the exact file path to create the new .html file.
Out-File -FilePath "HardwareInventoryHTMLReportFor$($computername)PC.html"

# Finally, Invoke-Item cmdlet is used to open the newly created .html file.
Invoke-Item -Path "HardwareInventoryHTMLReportFor$($computername)PC.html"