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


@echo OFF
REM WinUpdate2PS4.0
REM ---------------
wusa Windows6.1-KB2819745-x64-MultiPkg.msu /quiet /norestart


REM Configure local policy to change unindentified NIC's from public2work status
REM ----------------------------------------------------------------------------
regedit.exe /S Set_Unidentified_Networks_Private.reg


REM Message to user that setup is complete
REM --------------------------------------
cscript MessageBox.vbs "First step is finished. Windows will now restart!"


REM And now we restart
REM ------------------
shutdown -t 0 -r -f