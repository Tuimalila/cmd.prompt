@echo off
REM We need a special .cmd file to configure WinRM as this command breaks Install.Ansambl-2.bat
REM -------------------------------------------------------------------------------------------
winrm set winrm/config/service @{AllowUnencrypted="true"}
exit