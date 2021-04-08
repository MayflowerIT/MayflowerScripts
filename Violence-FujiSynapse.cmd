@echo off

reg delete "HKCU\Software\Fuji Medical Systems USA\Synapse\Workstation" /v currentDictatingStudies 	/f
reg delete "HKCU\Software\Fuji Medical Systems USA\Synapse\Workstation" /v lastNotifiedStudies 		/f


taskkill /im FujiSynapseBridge.exe
taskkill /im FujiSynapseBridge.exe /f
taskkill /im explorer.exe
taskkill /im explorer.exe /f

ping -n 2 127.0.0.1
start "Windows Explorer" explorer.exe
