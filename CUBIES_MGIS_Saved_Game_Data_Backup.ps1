<#
.SYNOPSIS
CUBIES_MGIS_Saved_Game_Data_Backup

.DESCRIPTION
This Powershell script backs up all Game Emulators' Saved Game Data to a separate
backup folder named SAVED GAME DATA within BACKUPS located in D:\ Drive. It backups
all GBA, MAME, MD, N64, NDS, NES, PC, PS1, PS2, PSP, and SNES saved game data.
#>

# Assign variables to all source paths applicable to each Game Emulator
$SourceGBA = "D:\INSTALLERS\Games\DEE_GAMES\DEE_EMULATORS\GBA\GBA Games\*"
$SourceMAME = "D:\INSTALLERS\Games\DEE_GAMES\DEE_EMULATORS\MAME\mame0174b_64bit\sta\*"
$SourceMD = "D:\INSTALLERS\Games\DEE_GAMES\DEE_EMULATORS\MD\MD Games\*"
$SourceN64 = "C:\Program Files (x86)\Project64 2.3\Save\*"
$SourceNDSA = "D:\INSTALLERS\Games\DEE_GAMES\DEE_EMULATORS\NDS\desmume-0.9.11-win64\Battery\*"
$SourceNDSB = "D:\INSTALLERS\Games\DEE_GAMES\DEE_EMULATORS\NDS\desmume-0.9.11-win64\States\*"
$SourceNESA = "D:\INSTALLERS\Games\DEE_GAMES\DEE_EMULATORS\NES\RockNES X\Battery\*"
$SourceNESB = "D:\INSTALLERS\Games\DEE_GAMES\DEE_EMULATORS\NES\RockNES X\savegames\*"
$SourcePS1A = "D:\INSTALLERS\Games\DEE_GAMES\DEE_EMULATORS\PS1\epsxe170\memcards\*"
$SourcePS1B = "D:\INSTALLERS\Games\DEE_GAMES\DEE_EMULATORS\PS1\epsxe170\sstates\*" 
$SourcePS2 = "C:\Users\Ronald Ong Dee\Documents\PCSX2\*"
$SourcePSP = "D:\INSTALLERS\Games\DEE_GAMES\DEE_EMULATORS\PSP\PPSSPP_WIN\PPSSPP\memstick\PSP\*"
$SourceSNES = "D:\INSTALLERS\Games\DEE_GAMES\DEE_EMULATORS\SNES\SNES Games\*"

# Assign variables to all destination paths applicable to each Game Emulator
$DestGBA = "D:\BACKUPS\SAVED GAME DATA\GBA Saved Game Data"
$DestMAME = "D:\BACKUPS\SAVED GAME DATA\MAME Saved Game Data"
$DestMD = "D:\BACKUPS\SAVED GAME DATA\MD Saved Game Data"
$DestN64 = "D:\BACKUPS\SAVED GAME DATA\N64 Saved Game Data"
$DestNDS = "D:\BACKUPS\SAVED GAME DATA\NDS Saved Game Data"
$DestNES = "D:\BACKUPS\SAVED GAME DATA\NES Saved Game Data"
$DestPS1 = "D:\BACKUPS\SAVED GAME DATA\PS1 Saved Game Data"
$DestPS2 = "D:\BACKUPS\SAVED GAME DATA\PS2 Saved Game Data"
$DestPSP = "D:\BACKUPS\SAVED GAME DATA\PSP Saved Game Data"
$DestSNES = "D:\BACKUPS\SAVED GAME DATA\SNES Saved Game Data"

# Check if any of the source paths does not exist though ! operator with the first set of Test-Path cmdlet. 
# If true, the CUBIES MGIS Saved Game Data will prevent execution and an error message will be triggered.
# Otherwise, the execution goes to elseif where a final set of checks with the second set of Test-Path cmdlet 
# plus -and operator to verify if all source paths does exists. Finally, all statements enclosed within elseif 
# are eventually executed. 
if (!(Test-Path $SourceGBA))
{
	Write-Error "`nCUBIES MGIS Saved Game Data Backup cannot be executed because GBA Source Path does not exist."
}
if (!(Test-Path $SourceMAME))
{
	Write-Error "`nCUBIES MGIS Saved Game Data Backup cannot be executed because MAME Source Path does not exist."
}
if (!(Test-Path $SourceMD))
{
	Write-Error "`nCUBIES MGIS Saved Game Data Backup cannot be executed because MD Source Path does not exist."
}
if (!(Test-Path $SourceN64))
{
	Write-Error "`nCUBIES MGIS Saved Game Data Backup cannot be executed because N64 Source Path does not exist."
}
if (!(Test-Path $SourceNDSA))
{
	Write-Error "`nCUBIES MGIS Saved Game Data Backup cannot be executed because NDS Source Path does not exist."
}
if (!(Test-Path $SourceNDSB))
{
	Write-Error "`nCUBIES MGIS Saved Game Data Backup cannot be executed because NDS Source Path does not exist."
}
if (!(Test-Path $SourceNESA))
{
	Write-Error "`nCUBIES MGIS Saved Game Data Backup cannot be executed because NES Source Path does not exist."
}
if (!(Test-Path $SourceNESB))
{
	Write-Error "`nCUBIES MGIS Saved Game Data Backup cannot be executed because NES Source Path does not exist."
}
if (!(Test-Path $SourcePS1A))
{
	Write-Error "`nCUBIES MGIS Saved Game Data Backup cannot be executed because PS1 Source Path does not exist."
}
if (!(Test-Path $SourcePS1B))
{
	Write-Error "`nCUBIES MGIS Saved Game Data Backup cannot be executed because PS1 Source Path does not exist."
}
if (!(Test-Path $SourcePS2))
{
	Write-Error "`nCUBIES MGIS Saved Game Data Backup cannot be executed because PS2 Source Path does not exist."
}
if (!(Test-Path $SourcePSP))
{
	Write-Error "`nCUBIES MGIS Saved Game Data Backup cannot be executed because PSP Source Path does not exist."
}
if (!(Test-Path $SourceSNES))
{
	Write-Error "`nCUBIES MGIS Saved Game Data Backup cannot be executed because SNES Source Path does not exist."
}
elseif ((Test-Path $SourceGBA) -and (Test-Path $SourceMAME) -and (Test-Path $SourceMD) -and (Test-Path $SourceN64) -and (Test-Path $SourceNDSA) `
-and (Test-Path $SourceNDSB) -and (Test-Path $SourceNESA) -and (Test-Path $SourceNESB) -and (Test-Path $SourcePS1A) -and (Test-Path $SourcePS1B) `
-and (Test-Path $SourcePS2) -and (Test-Path $SourcePSP) -and (Test-Path $SourceSNES))
{
	# Check if destination paths does not exists though ! operator with the third set of Test-Path cmdlet. If true, the non-existing destination path 
	# will be created with New-Path cmdlet in addition to -ItemType parameter is set to Directory, -Path parameter is set to the corresponding Game 
	# Emulator destination path variable, -Force parameter to disable any prompt, and -Verbose parameter to obtain additional information about the 
	# action a cmdlet performs.
	if (!(Test-Path $DestGBA))
	{
		New-Item -ItemType Directory -Path $DestGBA -Force -Verbose
	}
	if (!(Test-Path $DestMAME))
	{
		New-Item -ItemType Directory -Path $DestMAME -Force -Verbose
	}
	if (!(Test-Path $DestMD))
	{
		New-Item -ItemType Directory -Path $DestMD -Force -Verbose
	}
	if (!(Test-Path $DestN64))
	{
		New-Item -ItemType Directory -Path $DestN64 -Force -Verbose
	}
	if (!(Test-Path $DestNDS))
	{
		New-Item -ItemType Directory -Path $DestNDS -Force -Verbose
	}
	if (!(Test-Path $DestNES))
	{
		New-Item -ItemType Directory -Path $DestNES -Force -Verbose
	}
	if (!(Test-Path $DestPS1))
	{
		New-Item -ItemType Directory -Path $DestPS1 -Force -Verbose
	}
	if (!(Test-Path $DestPS2))
	{
		New-Item -ItemType Directory -Path $DestPS2 -Force -Verbose
	}
	if (!(Test-Path $DestPSP))
	{
		New-Item -ItemType Directory -Path $DestPSP -Force -Verbose
	}
	if (!(Test-Path $DestSNES))
	{
		New-Item -ItemType Directory -Path $DestSNES -Force -Verbose
	}	

	# Use the Copy-Item cmdlet to copy files from -Path parameter to -Destination parameter with -Recurse parameter to access subdirectories, 
	# -Exclude to exclude other file extensions, -Force parameter without any prompt, and -Verbose parameter to obtain additional information 
	# about the action a cmdlet performs..

	# VisualBoy Advance (GBA)
	Copy-Item -Path $SourceGBA -Destination $DestGBA -Exclude *.gba, *.jpg, *.png, *.gif -Recurse -Force -Verbose

	# MAME (MAME)
	Copy-Item -Path $SourceMAME -Destination $DestMAME -Recurse -Force -Verbose

	# Fusion (MD)
	Copy-Item -Path $SourceMD -Destination $DestMD -Exclude *.md, *.jpg -Recurse -Force -Verbose

	# Project 64 2 (N64)
	Copy-Item -Path $SourceN64 -Destination $DestN64 -Recurse -Force -Verbose

	# DeSmuME (NDS)
	Copy-Item -Path $SourceNDSA -Destination $DestNDS -Recurse -Force -Verbose
	Copy-Item -Path $SourceNDSB -Destination $DestNDS -Recurse -Force -Verbose

	# RockNES X (NES)
	Copy-Item -Path $SourceNESA -Destination $DestNES -Recurse -Force -Verbose
	Copy-Item -Path $SourceNESB -Destination $DestNES -Recurse -Force -Verbose

	# ePSXe (PS1)
	Copy-Item -Path $SourcePS1A -Destination $DestPS1 -Recurse -Force -Verbose
	Copy-Item -Path $SourcePS1B -Destination $DestPS1 -Recurse -Force -Verbose

	# PCSX2 (PS2)
	Copy-Item -Path $SourcePS2 -Destination $DestPS2 -Recurse -Force -Verbose

	# PPSSPP (PSP)
	Copy-Item -Path $SourcePSP -Destination $DestPSP -Recurse -Force -Verbose

	# BSNES (SNES)
	Copy-Item -Path $SourceSNES -Destination $DestSNES -Exclude *.sfc, *.jpg, *.png, *.gif -Recurse -Force -Verbose

	# Write-Host cmdlet displays a confirmation that the CUBIES MGIS Saved Game Data Backup script runs successfully on current date with Get-Date cmdlet
	# plus -ForegroundColor and -BackgroundColor adding emphasis on the confirmation. `n represents newline character.
	Write-Host "`nCUBIES MGIS Saved Game Data Backup was completed on $(Get-Date)." -ForegroundColor White -BackgroundColor Blue
}