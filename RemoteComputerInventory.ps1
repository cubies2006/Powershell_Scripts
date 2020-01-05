<#
.SYNOPSIS
RemoteComputerInventory

.DESCRIPTION
This Powershell function checks the connectivity of all computers in a given network
and displays important specification (Computer, Manufacturer, Model, Processor, System
Type, Operating System, OS Version, OS Build Version, Serial Number, IP Address, MAC
Address, Last User, Last User Login, C: Capacity, C: Freespace, D: Capacity, D: Freespace,
Total Memory, and Last Boot) on each of them in a .CSV file. This is very useful in
getting system information of multiple PCs across a given network.
#>

function Show-RemoteComputerInventoryInCSV
{
	# List down all computer names on computers.txt
	$testcomputers = Get-Content -Path 'D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\ListOfComputers.txt'

	# The final destination path of the generated RemnoteComputerInventory.csv file
	$exportLocation = 'D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\RemoteComputerInventory.csv'

	# If both LivePCs.txt and DeadPCs.txt files have contents, this simply clears all existing contents with Clear-Content cmdlet. 
	Clear-Content -path 'D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\LivePCs.txt'
	Clear-Content -path 'D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\DeadPCs.txt'
			
	# Test the connection of each computer before getting the inventory information in foreach loop using the $testcomputers. 
	foreach ($computer in $testcomputers)
	{
		# With the use of Test-Connection cmdlet which sends ICMP echo requests or pings to one or more computers specified with -Computername parameter, 
		# the -Quiet parameter forces it to return only a Boolean value of either $True or $False, and the -Count parameter determines the number of times 
		# the ping will be performed.
		if (Test-Connection -Computername $computer -Quiet -Count 2)
		{
			# If $true, this If statement will be executed where the available PC will be stored in LivePCs.txt via Add-Content cmdlet.
			Add-Content -value $computer -path 'D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\LivePCs.txt'
		}
		else
		{
			# If $false, this Else statement will be executed where the not available PC will be stored in DeadPCs.txt via Add-Content cmdlet.
			Add-Content -value $computer -path 'D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\DeadPCs.txt'
		}
	}

	# Get-Content cmdlet retrieves each computername per line from LivePCs.txt and stores it in a $computers variable.
	$computers = Get-Content -Path 'D:\POST-COLYMPIC_ERA\Important_Stuff\Computer-Related\Programming_Projects\Powershell_Scripts\LivePCs.txt'

	# Now that we know which PCs are live on the network proceed with the inventory of each computer's system specifications through foreach loop
	foreach ($computer in $computers)
	{
		# Get BIOS information
		$Bios = Get-WmiObject win32_Bios -Computername $computer

		# Get Hardware information
		$Hardware = Get-WmiObject win32_ComputerSystem -Computername $computer
		
		# Get System Build information
		$Sysbuild = Get-WmiObject win32_WmiSetting -Computername $computer

		# Get Operating System information
		$OS = Get-WmiObject win32_OperatingSystem -Computername $computer

		# Get Network Adapter Configuration information where Where-Object cmdlet is passed down the pipeline through IPEnabled property
		$Networks = Get-WmiObject win32_NetworkAdapterConfiguration -Computername $computer | Where-Object {$_.IPEnabled}

		# Get the Volume of Drive C's capacity and free space customized properties
		$DriveC = Get-WmiObject win32_Volume -Computername $computer -Filter 'drivetype = 3' |
		Select-Object PSComputerName, driveletter, 
		@{label = 'GBCapacity'; expression = {'{0:N2}' -f($_.capacity/1GB)}},
		@{label = 'GBFreeSpace'; expression = {'{0:N2}' -f($_.freespace/1GB)}} | Where-Object {$_.driveletter -match 'C:'}	
		
		# Get the Volume of Drive D's capacity and free space customized properties
		$DriveD = Get-WmiObject win32_Volume -Computername $computer -Filter 'drivetype = 3' |
		Select-Object PSComputerName, driveletter,
		@{label = 'GBCapacity'; expression = {'{0:N2}' -f($_.capacity/1GB)}}, 
		@{label = 'GBFreeSpace'; expression = {'{0:N2}' -f($_.freespace/1GB)}} | Where-Object {$_.driveletter -match 'D:'}
		
		# Get the Processor information 
		$CPU = Get-WmiObject win32_Processor -Computername $computer

		# Get the Current Username's Last Write Time property where its name equals Ronald Ong Dee
		$Username = Get-ChildItem "\\$computer\c$\Users" | Sort-Object LastWriteTime -Descending | 
		Select-Object Name, LastWriteTime | Where-Object {$_.name -eq "Ronald Ong Dee"}

		# Get the Hardware's Total Physical Memory Size by dividing 1024 three times and round it to 2 with [math]::round .NET math function
		$TotalMemory = [math]::round($Hardware.TotalPhysicalMemory/1024/1024/1024, 2)

		# Get the Operating System's Last Boot Up Time property and use ConvertToDateTime() method to set to datetime format
		$LastBoot = $OS.ConvertToDateTime($OS.LastBootUpTime)
		
		# Get the first IP Address from the array
		$IPAddress = $Networks.IpAddress[0]
		
		# Get the first MAC Address from the array
		$MACAddress = $Networks.MACAddress[0]
		
		# Get the BIOS' serial number property
		$SystemBios = $Bios.SerialNumber
		
		# Create an ordered hash table with [ordered] type which stores all custom properties' names and values, it is then stored in $specs variable
		$specs = [ordered]@{
			'ComputerName' = $computer.ToUpper()
			'Manufacturer' = $Hardware.Manufacturer
			'Model' = $Hardware.Model
			'Processor Type' = $CPU.Name
			'System Type' = $Hardware.SystemType
			'Operating System' = $OS.Caption
			'OS Version' = $OS.Version
			'OS Build Version' = $Sysbuild.BuildVersion
			'Serial Number' = $SystemBios
			'IP Address' = $IPAddress
			'MAC Address' = $MACAddress
			'Last User' = $Username.Name
			'User Last Login' = $Username.LastWriteTime
			'Drive C:\ Capacity (GB)' = $DriveC.GBCapacity
			'Drive C:\ Free Space (GB)' = $DriveC.GBFreeSpace
			'Drive D:\ Capacity (GB)' = $DriveD.GBCapacity
			'Drive D:\ Free Space (GB)' = $DriveD.GBFreeSpace
			'Total Memory (GB)' = $TotalMemory
			'Last Boot' = $LastBoot
		}
		
		# $outputObj is declared and assigned to New-Object cmdlet with -Type parameter set to PSObject and -Property parameter set to $specs
		$outputObj = New-Object -Type PSObject -Property $specs 

		# $outputObj is then pipelined to Export-CSV cmdlet with the -Path parameter set as $exportLocation plus both -Append and -NoTypeInformation 
		# switch parameters are enabled
		$outputObj | Export-CSV -Path $exportLocation -Append -NoTypeInformation
	}

	# Finally, the newly created .csv file of $exportLocation path is opened with Invoke-Item cmdlet
	Invoke-Item $exportLocation
}