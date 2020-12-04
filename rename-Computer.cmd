@echo off

echo "Existing name:	%1".
echo "New name:	%2".
echo "Domain\Administrator: %USERDOMAIN%\%USERNAME%".
echo.

netdom renamecomputer %1 /newname:%2 /userd:%USERDOMAIN%\%USERNAME% /passwordd:* /usero:%USERDOMAIN%\%USERNAME% /passwordo:* /reboot:10
