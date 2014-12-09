@echo off
cls
SET PWD=%~dp0
SET TARG=%1
SET CYGWIN=%PWD%misc\bin\win64\
SET TEMPDIR=%PWD%cached/%TARG%\
SET JLINK=%PWD%JLinkWin/JLink.exe
SET DEVICEROOT=%PWD%devices\
SET DEVICEDIR=%DEVICEROOT%%TARG%

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

%JLINK% -device nrf51422 -if swd -speed 4000 -CommanderScript %TEMPDIR%flash.jlink

SET DEVICEINFO=%TEMPDIR%device.info

for /f %%i in ("%DEVICEINFO%") do set "size=%%~zi"
if not defined size set size=0
if %size% gtr 0 (
    echo Blob found
) else (
    echo  Unable to readback
    goto :fail
)


FOR /F "tokens=1 delims=\\ " %%i in ("%CYGWIN%/sha1sum.exe %DEVICEINFO%") do SET SHA=%%i

%CYGWIN%mv %DEVICEINFO% %DEVICEDIR%/%SHA%


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