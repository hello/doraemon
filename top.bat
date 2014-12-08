@echo off
cls
SET PWD=%~dp0
SET TARG=%1
SET CYGWIN=%PWD%misc\bin\win64\
SET TEMPDIR=%PWD%temp

IF NOT EXIST %TEMPDIR% (
	echo "Creating temporary directory"
	mkdir %PWD%temp
)

SET TARGFOLDER=%PWD%targets\%TARG%
IF NOT EXIST %TARGFOLDER% (
	echo "target directory does not exist"
	goto :fail
)




	echo "****************************************************"
	echo "*                                                  *"
	echo "*                       PASS                       *"
	echo "*                                                  *"
	echo "****************************************************"
:fail
	echo "****************************************************"
	echo "*                                                  *"
	echo "*                       FAIL                       *"
	echo "*                                                  *"
	echo "****************************************************"
	goto :eof
:eof