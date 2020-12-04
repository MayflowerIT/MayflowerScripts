@echo off

::
: If these are not installed in order, then the server component won't install.
: See http://thehotfixshare.net/board/index.php?showtopic=20729
::


wusa Windows6.1-KB2574819-v2-x64.msu	/quiet /norestart
wusa Windows6.1-KB2592687-x86.msu	/quiet /norestart
wusa Windows6.1-KB2857650-x64.msu	/quiet /norestart
wusa Windows6.1-KB2830477-x64.msu	/quiet /norestart
wusa Windows6.1-KB2913751-x64.msu	/quiet /norestart
wusa Windows6.1-KB2923545-x64.msu	/quiet /norestart
wusa Windows6.1-KB2965788-x64.msu	/quiet /norestart
wusa Windows6.1-KB2985461-x64.msu	/quiet /norestart
wusa Windows6.1-KB2984972-x64.msu	/quiet /norestart
wusa Windows6.1-KB2984976-x64.msu	/quiet /norestart
