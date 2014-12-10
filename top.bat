@echo off
cls
SET PWD=%~dp0
SET TARG=%1
SET TEMPDIR=%PWD%cached/%TARG%\
SET JLINK=%PWD%JLinkWin/JLink.exe
SET DEVICEROOT=%PWD%devices\
SET DEVICEDIR=%DEVICEROOT%%TARG%

if defined ProgramFiles(x86) (
	echo "Win 64 Detected"
	SET CYGWIN=%PWD%misc\bin\win64\
) else (
	echo "Win 32 Detected"
	SET CYGWIN=%PWD%misc\bin\win32\
)

IF NOT EXIST  %TEMPDIR% (
	echo "target directory does not exist"
	goto :fail
)

IF NOT EXIST  %DEVICEROOT% (
	echo "device root directory does not exist, creating"
	mkdir %DEVICEROOT%
)
IF NOT EXIST  %DEVICEDIR% (
	echo "device directory does not exist, creating"
	mkdir %DEVICEDIR%
)
%CYGWIN%cp.exe -f -v %PWD%targets/%TARG%/*.{bin,crc} %TEMPDIR%
%JLINK% -device nrf51422 -if swd -speed 2000 -CommanderScript %TEMPDIR%flash.jlink

SET DEVICEINFO=%TEMPDIR%device.info

for /f %%i in ("%DEVICEINFO%") do set "size=%%~zi"
if not defined size set size=0
if %size% gtr 0 (
    echo Blob found
) else (
    echo  Unable to readback
    goto :fail
)
SET INFONAME=
SET /p INFONAME=Enter SN:
IF "%INFONAME%" == "" (
	echo "No name input, using SHA1 as default name"
	FOR /F "tokens=1 delims=\\ " %%i in ('%CYGWIN%/sha1sum.exe %DEVICEINFO%') do SET SHA=%%i
	%CYGWIN%mv %DEVICEINFO% %DEVICEDIR%/%SHA%
) else (
	%CYGWIN%mv %DEVICEINFO% %DEVICEDIR%/%INFONAME%
)



	echo "****************************************************"
	echo "*                                                  *"
	echo "*                       PASS                       *"
	echo "*                                                  *"
	echo "****************************************************"
goto :eof
:fail
	echo "****************************************************"
	echo "*                                                  *"
	echo "*                       FAIL                       *"
	echo "*                                                  *"
	echo "****************************************************"
	goto :eof
:eof