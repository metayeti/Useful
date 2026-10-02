<#
.SYNOPSIS
    Removes Windows 11 rounded window corners for the specified process windows.

.DESCRIPTION
    Uses Desktop Window Manager (DWM) API calls via C# P/Invoke to apply the 
    DWMWA_WINDOW_CORNER_PREFERENCE attribute (33) set to DWMWCP_DONOTROUND (1).

.PARAMETER ProcessNames
    One or more process names (without .exe extension) to target. Mandatory parameter.

.EXAMPLE
    .\no-rounded-corners.ps1 -ProcessNames "notepad", "chrome"

.EXAMPLE
    .\no-rounded-corners.ps1 "notepad"
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
    [ValidateNotNullOrEmpty()]
    [string[]]$ProcessNames
)

Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class DwmApi {
    [DllImport("dwmapi.dll")]
    public static extern int DwmSetWindowAttribute(
        IntPtr hwnd,
        int attribute,
        ref int value,
        int valueSize
    );
}
"@

# DWMWA_WINDOW_CORNER_PREFERENCE = 33
# DWMWCP_DONOTROUND = 1
$attribute = 33
$value = 1

foreach ($name in $ProcessNames) {
    $processes = Get-Process -Name $name -ErrorAction SilentlyContinue

    if (-not $processes) {
        Write-Warning "No running processes found matching '$name'."
        continue
    }

    foreach ($process in $processes) {
        $hwnd = $process.MainWindowHandle

        if ($hwnd -ne [IntPtr]::Zero) {
            $result = [DwmApi]::DwmSetWindowAttribute(
                $hwnd,
                $attribute,
                [ref]$value,
                [System.Runtime.InteropServices.Marshal]::SizeOf([type][int])
            )

            if ($result -eq 0) {
                Write-Host "Disabled rounded corners for $name (PID $($process.Id), HWND $hwnd)" -ForegroundColor Green
            }
            else {
                Write-Host "DwmSetWindowAttribute failed for $name (HRESULT 0x$($result.ToString('X')))" -ForegroundColor Red
            }
        }
    }
}