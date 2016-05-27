@ECHO OFF

ECHO Welcome to use GWX - Get Windows 10 Removal Tool
ECHO For more information please visit http://wangye.org
ECHO.

REM See http://stackoverflow.com/questions/4051883/batch-script-how-to-check-for-admin-rights
goto check_Permissions

:check_Permissions
    echo Administrative permissions required. Detecting permissions...

    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Success: Administrative permissions confirmed.
    ) else (
        echo Failure: Current permissions inadequate.
	GOTO Done
    )


ECHO Terminating process GWX.exe....
taskkill /F /IM GWX.exe
ECHO GWX.exe terminated.

ECHO Uninstalling KB3035583 Update, Please wait...
start "title" /b /wait WUSA.exe /quiet /norestart /uninstall /kb:3035583
ECHO KB3035583 uninstalled.

ECHO Adding Policy For Disable Gwx Software...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Gwx" /v DisableGwx /t REG_DWORD /d 1 /f
ECHO DisableGwx Policy Added.

ECHO Removing GWX directory...
del /f /s /a /q %SystemRoot%\System32\GWX
ECHO GWX directory removed.

ECHO Hiding GWX Updates, Please wait...
start "title" /b /wait cscript.exe //NoLogo "%~dp0HideWindowsUpdates.vbs" 3035583
ECHO Done.

ECHO All steps completed, Please restart your computer!

:Done
PAUSE