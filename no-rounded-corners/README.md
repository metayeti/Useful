# no-rounded-corners

This is a PowerShell script that removes rounded corners from an active Windows 11 program's window. I use it to get clean game screenshots but you may find other uses for it.

How to use:

```PowerShell
# -- if you're in powershell (prefer this): --

# Will ask for process names to target
.\no-rounded-corners.ps1

# Will target the "game1" process
.\no-rounded-corners.ps1 "game1"

# Will target "game1" and "game2" processes
.\no-rounded-corners.ps1 -ProcessNames "game1", "game2"


# -- if you're in cmd: --

powershell -ExecutionPolicy Bypass -File .\no-rounded-corners.ps1
powershell -ExecutionPolicy Bypass -File .\no-rounded-corners.ps1 "game1"
powershell -ExecutionPolicy Bypass -Command ".\no-rounded-corners.ps1 -ProcessNames 'game1','game2'"
"""
```
