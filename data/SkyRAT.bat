@echo off

rem set /p home=<C:\tmp\skyhome.txt
rem echo @echo off>C:\Windows\System32\skyrat.bat
rem set drive=%home:~0,2%
rem echo | set /p ="%drive%" >>C:\Windows\System32\skyrat.bat
rem echo. >>C:\Windows\System32\skyrat.bat
rem echo | set /p ="%home%\SkyRAT.lnk" >>C:\Windows\System32\skyrat.bat

echo | set /p ="@echo off">C:\Windows\System32\skyrat.bat
echo. >>C:\Windows\System32\skyrat.bat
echo | set /p ="set /p home=<C:\tmp\skyhome.txt">>C:\Windows\System32\skyrat.bat
echo. >>C:\Windows\System32\skyrat.bat
echo | set /p ="powershell -c "%%home%%\data\main.ps1"" >>C:\Windows\System32\skyrat.bat
cls

IF NOT EXIST data\main.ps1 cd ..
powershell.exe -c ".\data\main.ps1"

