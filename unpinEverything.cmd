@ECHO On
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION


SET TYPE=Taskbar


REM for /d %%j in ( "\\%ComputerDNSDomain%\home$\%UserName%\Application Data\Microsoft\Internet Explorer\Quick Launch\User Pinned\%TYPE%" "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\%TYPE%" ) do (

REM pushd %%j

:UNPIN
::pushd "\\%ComputerDNSDomain%\home$\%UserName%\Application Data\Microsoft\Internet Explorer\Quick Launch\User Pinned\%TYPE%" || exit /b 1
:UNPIN2
pushd "%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\%TYPE%" || exit /b 1

if "%TYPE%"=="Taskbar" ( SET SLASHTYPE=/%TYPE% ) ELSE ( SET SLASHTYPE= )

echo Unpinning %TYPE%...
for %%i in (*.lnk) do (
	echo %%i
	cscript /b %NETlogon%\UnpinItem.vbs /item:"%CD%\%%i" %SLASHTYPE%
	del /q "%CD%\%%i"
)
popd

if "%TYPE%"=="Taskbar" (
	SET TYPE=StartMenu
	GOTO :UNPIN
)

::if "%AppData%"=="\\%ComputerDNSDomain%\home$\%UserName%"

REM )

%NETLOGON%\pinQuickLaunchToTaskbar.cmd
