@echo OFF
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
   echo ######### ERROR: ADMINISTRATOR PRIVILEGES REQUIRED ###########
   echo.
   echo This script must be run as administrator to work properly!  
   echo.
   echo If you're seeing this after doubleclicking on a icon, then 
   echo right click on the shortcut and select "Run As Administrator".
   echo.
   echo ##############################################################
   echo.
   PAUSE
   EXIT /B 1
)
@echo off

REM 1st we unzip all required files
REM @echo Current directory is: %CD%
REM If we run as an administrator we need to change directory back to script location
cd /D "%~dp0"
@echo Current directory is: %CD%
7z.exe x tools.zip -r -y -oC:\
cls
type C:\tools\setup\install.txt

REM we generate a new guid file
del c:\tools\status\guid.txt
cscript //NoLogo C:\tools\setup\myuuid.vbs >> c:\tools\status\guid.txt

REM Install prerequisite software
C:\tools\setup\vcredist_x86.exe /q /norestart
C:\tools\setup\ReportViewer.exe /q:a /c:”install.exe /q /l 
call C:\tools\setup\NDP452-KB2901907-x86-x64-AllOS-ENU.exe /passive /norestart

REM Add Wamp to autostart programs
copy "c:\tools\wamp\wamp.lnk" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\"

REM Then we run wamp
start cmd /k C:\tools\wamp\wamp.bat

REM After we start SoftEther installation and tell the user to enable RemoteEnable
cscript C:\tools\setup\MessageBox.vbs "Installing SoftEther, just accept default values and click next."
call C:\tools\setup\softether-vpnclient-v4.20-9608-rtm-2016.04.17-windows-x86_x64-intel.exe
cscript C:\tools\setup\MessageBox.vbs "Also please disable SoftEther updates in the Help - About - Configure Updates"
cscript C:\tools\setup\MessageBox.vbs "I will open vpncmd where you please enable 'RemoteEnable' for local client"
start cmd /k  "C:\Program Files\SoftEther VPN Client\vpncmd_x64.exe"
cscript C:\tools\setup\MessageBox.vbs "How to 'RemoteEnable' for local client - Choose number 2, Press Enter, Press Enter again, type RemoteEnable, press Enter and then close this new window"

REM Message to user to install Middleware
cscript C:\tools\setup\MessageBox.vbs "Now we are going to install Middleware. Please cklick on Install button on the next dialog window."
call C:\tools\setup\setup.exe
cls
echo ################################################################################
echo.
echo Please press Install button on the Application Install - Security Warning window
echo.
echo Script is waiting for 45 seconds for Middleware installation to finish
echo.
timeout /t 45 /nobreak
taskkill /IM Middleware.exe /F
cls

REM Start Wizzard
cscript C:\tools\setup\MessageBox.vbs "In the final step please input the serial number into Wizard. After Wizard restarts Windows, please run it again from Desktop to let it finish the setup."
taskkill /IM Middleware.exe /F
cls
copy "C:\tools\Wizard.exe.lnk" "C:\Users\Public\Desktop\"
cls
type C:\tools\setup\install.txt
C:\tools\Wizard.exe
exit

REM And now we restart
REM cscript C:\tools\setup\MessageBox.vbs "We will restart the computer."
REM shutdown -t 0 -r -f