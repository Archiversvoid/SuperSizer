@echo off
setlocal enabledelayedexpansion

echo Sorting by size... (SuperSizer by Archivers_void)
echo --------------------------------------------------

set "tmpF=%temp%\sort_folders.txt"
if exist "%tmpF%" del "%tmpF%"

:: 1. Scan and build a sortable list
for /f "delims=" %%G in ('dir /b /ad') do (
    set "rSize=0"
    for /f "tokens=3" %%A in ('dir /s /-c "%%~G" 2^>nul ^| find "File(s)"') do (
        set "rSize=%%A"
    )

    :: Create a 15-digit padding so '1000' sorts above '20'
    set "pS=000000000000000!rSize!"
    set "pS=!pS:~-15!"

    :: Logic for GB vs MB display text
    if !rSize! GTR 1073741824 (
        set /a "gbV=!rSize:~0,-7! / 100"
        echo !pS!^|!gbV! GB^|%%G >> "%tmpF%"
    ) else (
        set /a "mbV=!rSize! / 1048576"
        echo !pS!^|!mbV! MB^|%%G >> "%tmpF%"
    )
)

echo No.   Size      Folder Name
echo --------------------------------------------------

:: 2. Sort Reverse (/R) and split by the pipe symbol
set "n=0"
for /f "tokens=2,3 delims=|" %%A in ('sort /r "%tmpF%" 2^>nul') do (
    set /a "n+=1"
    echo !n!.   %%A    %%B
)

if exist "%tmpF%" del "%tmpF%"
echo --------------------------------------------------
pause
