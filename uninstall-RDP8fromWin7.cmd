@echo off

::
: If RDP8 updates for Windows 7 aren't installed in the correct order, 
:  then the server component will not get installed and will not be 
:  installable. Solution: remove all of RDP8, then reinstall in order.
:: 

wusa /uninstall /kb:2984976 /quiet /norestart
wusa /uninstall /kb:2965788 /quiet /norestart
wusa /uninstall /kb:2923545 /quiet /norestart
wusa /uninstall /kb:2830477 /quiet /norestart

::wusa /uninstall /kb:2984972 /quiet /norestart
wusa /uninstall /kb:2985461 /quiet /norestart
wusa /uninstall /kb:2913751 /quiet /norestart
wusa /uninstall /kb:2857650 /quiet /norestart
::wusa /uninstall /kb:2592687 /quiet /norestart

