@rem ----[ This code block detects if the script is being running with admin PRIVILEGES If it isn't it pauses and then quits]-------
echo OFF
NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    ECHO Administrator PRIVILEGES Detected! 
) ELSE (
   echo ######## ########  ########   #######  ########  
   echo ##       ##     ## ##     ## ##     ## ##     ## 
   echo ##       ##     ## ##     ## ##     ## ##     ## 
   echo ######   ########  ########  ##     ## ########  
   echo ##       ##   ##   ##   ##   ##     ## ##   ##   
   echo ##       ##    ##  ##    ##  ##     ## ##    ##  
   echo ######## ##     ## ##     ##  #######  ##     ## 
   echo.
   echo.
   echo ####### ERROR: ADMINISTRATOR PRIVILEGES REQUIRED #########
   echo This script must be run as administrator to work properly!  
   echo If you're seeing this after clicking on a start menu icon, then right click on the shortcut and select "Run As Administrator".
   echo ##########################################################
   echo.
   PAUSE
   EXIT /B 1
)


@echo off
REM We create a user and add it to Admin group
REM ------------------------------------------
net user change_user change_password /ADD
net localgroup administrators change_user /add

REM We make sure that password doesn't expire
REM ------------------------------------------
wmic UserAccount set PasswordExpires=False


REM We need to enable execution of ps scripts
REM -----------------------------------------
regedit.exe /S EnableScripts.reg


REM And configure client for use with WinRM protocol
REM ------------------------------------------------
Powershell.exe -File Configure_Client_Ansible.ps1


REM Create a directory for Ansible and install programs
REM ---------------------------------------------------
if not exist "C:\tools\ansible\" mkdir C:\tools\ansible
if not exist "C:\tools\ansible\install" mkdir C:\tools\ansible\install


REM We also need to reset security descriptors on folders and files under C:\tools\
REM -------------------------------------------------------------------------------
icacls "C:\tools\ahk\*" /q /c /t /grant Users:F
icacls "C:\tools\ansible\*" /q /c /t /grant Users:F
icacls "C:\tools\autostart\*" /q /c /t /grant Users:F


REM Lastly we allow (un)encrypted traffic
REM (We need a special file as this config breaks the install script!)
REM ------------------------------------------------------------------
call Unencry-WinRM.cmd


REM Message to user that setup is complete
REM --------------------------------------
cscript MessageBox.vbs "Setup for Ansambl is Complete! Setup will now exit."


REM This cleans some unneeded files
REM -------------------------------
IF EXIST "C:\tools\ansible\ansible.zip" (
del C:\tools\ansible\ansible.zip
)
IF EXIST "C:\Users\TerminalAdmin\Desktop\ansible.zip" (
del C:\Users\TerminalAdmin\Desktop\ansible.zip
)


REM Delete this script
REM ------------------
( del /q /f "%~f0" >nul 2>&1 & exit /b 0  )