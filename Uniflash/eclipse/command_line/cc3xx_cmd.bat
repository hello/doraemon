@echo off
setlocal ENABLEDELAYEDEXPANSION

REM path of the batch file
set cwd=%~dp0
REM set path to the 32-bit JRE so it works for 64-bit windows
set PATH=%cwd%\..\jre\bin;%PATH%
REM path to eclipse plugin folder									
set PLUGINS_PATH=%cwd%\..\plugins
REM path to the command line jar					
set CLASSPATH_STRING=%cwd%\com.ti.uniflash.commandline.jar

REM stores the path to the common libs folder
set NATIVE_PATH_STRING=-Djna.library.path
REM stores the path to the latest wireless plugin folder
set WIRELESS_PLUGIN_PATH=-dependencyPath
REM temporary path of the wireless plugin folder for comparison
set TEMP_WIRELESS_PLUGIN_PATH=""

REM run the p2 garbage collector batch file (if it exists) to clean up the plugins folder
if exist %cwd%\p2gc.bat (
	call %cwd%\p2gc.bat
 	del %cwd%\p2gc.bat
	
	if exist %cwd%\p2gc.bat (
		echo ERROR deleting p2gc.bat, to prevent performance issues with the CLI tool, please manually delete p2gc.bat in %cwd%
	)
)

REM change directory to the plugin folder; if there is an error before the end, we will be in this folder
cd /d "%PLUGINS_PATH%"
REM stores the neccessary classpaths for command line to work					
set CC3X_DEPENDENCY="%CLASSPATH_STRING%";"%CD%\*"

REM walks through the plugin folder to look for cc3xxx and libs sub folders
for /d %%I in (*) do (
    if exist "%%I\cc3xxx\" (
		call :DependencyPath "%CD%\%%I\"
    )
	if exist "%%I\libs\" (
		call :LibPath "%CD%\%%I"
    )
)

REM only set this path after all the comparsions are done
set WIRELESS_PLUGIN_PATH=%WIRELESS_PLUGIN_PATH% %TEMP_WIRELESS_PLUGIN_PATH%

REM store entire line and replace \ with /
set FULL_COMMAND_LINE=%NATIVE_PATH_STRING% -cp %CC3X_DEPENDENCY% com.ti.uniflash.commandline.CommandLine %WIRELESS_PLUGIN_PATH% %*
set FULL_COMMAND_LINE=%FULL_COMMAND_LINE:\=/%

REM uncomment out next line for debugging
REM echo java %FULL_COMMAND_LINE%

java %FULL_COMMAND_LINE%

@echo off
cd /d "%cwd%"
goto:EOF

:DependencyPath
REM set the temp path if the path is currently empty
if %TEMP_WIRELESS_PLUGIN_PATH% EQU "" (
	set TEMP_WIRELESS_PLUGIN_PATH=%1
)
	
REM if the current path is greater than the temporary path (ie; it is newer), store it to the temp
if %TEMP_WIRELESS_PLUGIN_PATH% LSS %1 (
	set TEMP_WIRELESS_PLUGIN_PATH=%1
)
goto:EOF

:LibPath
REM if this is the common lib path, set the NATIVE_PATH_STRING variable
set str1=%1
REM remove the quotes for comparison/concatenation purposes
set str2=%str1:"=%

REM look for a path with uniflash.common.libs in it and store it in NATIVE_PATH_STRING 
if not x%str1:uniflash.common.libs=%==x%str1% set NATIVE_PATH_STRING=%NATIVE_PATH_STRING%="%str2%\libs\"

REM keep track of all of the lib paths in CC3X_DEPENDENCY
set CC3X_DEPENDENCY=%CC3X_DEPENDENCY%;"%str2%\libs\*"
set CC3X_DEPENDENCY=%CC3X_DEPENDENCY%;"%str2%\*"

goto:EOF
