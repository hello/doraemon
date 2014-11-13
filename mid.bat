if not "%~3"=="" (
	echo "Usage: mid.bat {target_name} {com port}"
	goto :fail
)
SET PWD=%~dp0
SET TARG=%1
SET COM=%2
SET TEMPDIR=%PWD%temp
IF NOT EXIST  %TEMPDIR% (
	echo "creating temporary directory"
	mkdir %PWD%temp
)

SET TARGFOLDER=%PWD%targets\%TARG%
IF NOT EXIST  %TARGFOLDER% (
	echo "target directory does not exist"
	goto :fail
)

SET TARGMIDSRC=%TARGFOLDER%\kitsune.bin
SET TARGTOPSRC=%TARGFOLDER%\morpheus+*.bin
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

IF NOT EXIST %TARGMIDDST% (
	echo "Copying kitsune"
	xcopy /y /v     "%TARGMIDSRC%" "%TARGMIDDST%"
)
IF NOT EXIST %TARGTOPDST% (
	echo "Copying Top Factory"
	xcopy /y /v    "%TARGTOPSRC%" "%TARGTOPDST%"
)
IF NOT EXIST %TARGHWDST% (
	echo "Copying hw version"
	xcopy /y /v    "%TARGHWSRC%"  "%TARGHWDST%"
)


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
