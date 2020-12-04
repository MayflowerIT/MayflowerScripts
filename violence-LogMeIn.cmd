@echo off


@if (%_echo%)==() echo off

REM - Allow LogMeIn to clean itself up before we slaughter it.
REM - call %~dp0\uninstall-logmein-graceful.bat
date /t
echo "Requesting clean uninstall."
wmic product where "name='%LogMeIn%'" call uninstall /nointeractive


date /t
echo "Requesting dirty uninstall."
if EXIST "%ProgramFiles%\LogMeIn\x64\LogMeIn.exe" "%ProgramFiles%\LogMeIn\x64\LogMeIn.exe" uninstall
if EXIST "%ProgramFiles%\LogMeIn\x86\LogMeIn.exe" "%ProgramFiles%\LogMeIn\x86\LogMeIn.exe" uninstall
if EXIST "%ProgramFiles(x86)%\LogMeIn\x64\LogMeIn.exe" "%ProgramFiles(x86)%\LogMeIn\x64\LogMeIn.exe" uninstall
if EXIST "%ProgramFiles(x86)%\LogMeIn\x86\LogMeIn.exe" "%ProgramFiles(x86)%\LogMeIn\x86\LogMeIn.exe" uninstall


date /t
echo "Uninstalling LogMeIn by violence. Reboot may be required."

for %%i in (LMIGuardianSvc LogMeIn LMIInfo LMImaint LMImirr LMIfsClinetNP LMIRfsDriver) do (
	net stop "%%i"
	net stop "%%i"
	sc delete "%%i"
	reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%%i" /f
)

for %%i in (LMIGuardian.exe LogMeIn.exe LogMeInSystray.exe ramaint.exe) do taskkill /IM "%%i" /f 

if EXIST "%ProgramFiles%\LogMeIn" rmdir /s /q "%ProgramFiles%\LogMeIn"
if EXIST "%ProgramFiles(x86)%\LogMeIn" rmdir /s /q "%ProgramFiles(x86)%\LogMeIn"
if EXIST "%ProgramData%\LogMeIn" rmdir /s /q "%ProgramData%\LogMeIn"

reg delete "HKEY_LOCAL_MACHINE\Software\LogMeIn" /f

reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "LogMeIn GUI" /f

REM - Not clear if this is per-instance, per-machine, or per-version. Seems to be global to LogMeIn?
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Installer\Products\1C4E50998D41225488EFDF005BA102CD" /f



REM - call %~dp0\clear-logmein-GPO-from-registry.bat
date /t
