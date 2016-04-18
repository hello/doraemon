@echo off
cls
IF "%2"=="" (
	echo Usage: mid.bat {target_name} {com port}
	goto :eof
)
SET PWD=%~dp0
SET TARG=%1
SET COM=%2
SET TEMPDIR=%PWD%temp

if defined ProgramFiles(x86) (
	echo "Win 64 Detected"
	SET CYGWIN=%PWD%misc\bin\win64\
) else (
	echo "Win 32 Detected"
	SET CYGWIN=%PWD%misc\bin\win32\
)
IF NOT EXIST  %TEMPDIR% (
	echo "creating temporary directory"
	mkdir %PWD%temp
)

SET TARGFOLDER=%PWD%targets\%TARG%
IF NOT EXIST  %TARGFOLDER% (
	echo "target directory does not exist"
	goto :fail
)

SET TARGMIDSRC=C:\Users\chrisjohnson\Desktop\kitsune\kitsune\main\ccs\exe\kitsune.bin
SET TARGTOPSRC=Z:\Projects\kodo\build\morpheus+morpheus_PVT1.bin
SET TARGHWSRC=%TARGFOLDER%\hw_ver.txt

IF NOT EXIST %TARGMIDSRC% (
	echo "midboard binary does not exist"
	goto :fail
)
IF NOT EXIST %TARGTOPSRC% (
	echo "topboard binary does not exist"
	goto :fail
)
IF NOT EXIST %TARGHWSRC% (
	echo "hardware version does not exist"
	goto :fail
)

SET TARGMIDDST=%TEMPDIR%\kitsune.bin
SET TARGTOPDST=%TEMPDIR%\factory.bin
SET TARGHWDST=%TEMPDIR%\hw_ver.txt

echo "Copying kitsune"
xcopy /y /v %TARGMIDSRC% %TARGMIDDST%
echo "Copying Top Factory"
xcopy /y /v %TARGTOPSRC% %TARGTOPDST%
echo "Copying hw version"
xcopy /y /v %TARGHWSRC%  %TARGHWDST%


CALL %PWD%Uniflash\flashit.bat %COM%
goto :eof

:fail
	echo "****************************************************"
	echo "*                                                  *"
	echo "*                       FAIL                       *"
	echo "*                                                  *"
	echo "****************************************************"
	goto :eof
:eof
