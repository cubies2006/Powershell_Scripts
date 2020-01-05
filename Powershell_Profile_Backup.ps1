<#
.SYNOPSIS
CustomizedPowershellTitleBar

.DESCRIPTION
This Powershell script changes the way Windows Powershell console host
is displayed by modifying its title bar with important information
about whether the Powershell is run as an Administrator or Not, whether
its a 32-bit (x86) or 64-bit (x64) system architecture, and the current
working directory which changes when the user moves in a different 
directory path.
#>

function prompt 
{
    if ([System.IntPtr]::Size -eq 8)
    {
        $size = '64 bit'
    }
    else 
    {
        $size = '32 bit'
    }
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $secprin = New-Object Security.Principal.WindowsPrincipal $currentUser
    if ($secprin.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator))
    {
        $admin = 'Administrator'
    }
    else
    {
        $admin = 'non-Administrator'
    }
    $host.ui.RawUI.WindowTitle = "$admin $size $(Get-Location)"
    "£> "
}