@echo off
cls
SET PWD=%~dp0
SET TARG=%1
SET INFONAME=%2
SET TEMPDIR=%PWD%temp\
SET CACHEDIR=%PWD%cached\%TARG%\
SET JLINK=%PWD%JLinkWin/JLink.exe
SET DEVICEROOT=%PWD%devices\
SET DEVICEDIR=%DEVICEROOT%%TARG%
SET EMU=%3

if defined ProgramFiles(x86) (
	echo "Win 64 Detected"
	SET CYGWIN=%PWD%misc\bin\win64\
) else (
	echo "Win 32 Detected"
	SET CYGWIN=%PWD%misc\bin\win32\
)
IF NOT EXIST  %CACHEDIR% (
	mkdir %CACHEDIR%
)
IF NOT EXIST  %TEMPDIR% (
	mkdir %TEMPDIR%
)
IF NOT EXIST  %DEVICEROOT% (
	echo "device root directory does not exist, creating"
	mkdir %DEVICEROOT%
)
IF NOT EXIST  %DEVICEDIR% (
	echo "device directory does not exist, creating"
	mkdir %DEVICEDIR%
)
%CYGWIN%rm.exe -f -v %TEMPDIR%/*.{bin,crc,jlink}
%CYGWIN%cp.exe -f -v %PWD%targets/%TARG%/*.{bin,crc} %TEMPDIR%
For %%f in (%TEMPDIR%*.crc) do rename "%%f" "%%~nf.crc.bin"
SET TEMPDIR=%TEMPDIR:\=/%
SET CACHEDIR=%CACHEDIR:\=/%
%CYGWIN%sed.exe -e "s,\$TEMP\/,%TEMPDIR%,g" -e "s,\$CACHE\/,%CACHEDIR%,g" %PWD%targets/%TARG%\app+bootloader.prod.in > %TEMPDIR%flash.jlink
%JLINK% -device nrf51422 -if swd -speed 2000 -SelectEmuBySN %EMU% -CommanderScript %TEMPDIR%flash.jlink

SET DEVICEINFO=%CACHEDIR%device.info

for /f %%i in ("%DEVICEINFO%") do set "size=%%~zi"
if not defined size set size=0
if %size% gtr 0 (
    echo Blob found
) else (
    echo  Unable to readback
    goto :fail
)
IF "%INFONAME%" == "" (
	echo "No name input, using SHA1 as default name"
	FOR /F "tokens=1 delims=\\ " %%i in ('%CYGWIN%/sha1sum.exe %DEVICEINFO%') do SET SHA=%%i
	%CYGWIN%mv %DEVICEINFO% %DEVICEDIR%/%SHA%
) else (
	%CYGWIN%mv %DEVICEINFO% %DEVICEDIR%/%INFONAME%
)
goto :eof
:fail
	echo "****************************************************"
	echo "*                                                  *"
	echo "*                       fail                       *"
	echo "*                                                  *"
	echo "****************************************************"
	exit 1
:eof
	exit 0
