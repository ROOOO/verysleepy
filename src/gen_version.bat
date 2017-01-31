@echo off
cd /d "%~dp0"

rem Generate a header file with the exact current version using git tags.
rem This file is ran as a pre-build step for the sleepy and crashreport projects.

rem Find git

if not defined GIT for %%a in (git.exe) do if not [%%~$PATH:a] == [] set GIT="%%~$PATH:a"
if not defined GIT if exist "%ProgramFiles(x86)%\Git\bin\git.exe" set GIT="%ProgramFiles(x86)%\Git\bin\git.exe"
if not defined GIT if exist "%ProgramFiles%\Git\bin\git.exe" set GIT="%ProgramFiles%\Git\bin\git.exe"
if not defined GIT if exist "%ProgramW6432%\Git\bin\git.exe" set GIT="%ProgramW6432%\Git\bin\git.exe"
if not defined GIT if exist "%SystemDrive%\Git\bin\git.exe" set GIT="%SystemDrive%\Git\bin\git.exe"
if not defined GIT echo gen_version.bat: Can't find git! & exit /b 1

rem Get git-describe output

for /f %%a in ('%GIT% describe --tags --dirty') do set VERSION=%%a
if errorlevel 1 exit /b 1
if [%VERSION%] == [] exit /b 1
echo #define VERSION "%VERSION:~1%" > version.h.tmp

rem Only update version.h if it changed, to avoid recompiling every time.

if not exist version.h goto write
fc version.h version.h.tmp > nul
if errorlevel 1 goto write
del version.h.tmp
goto :eof

:write
move /Y version.h.tmp version.h
goto :eof
