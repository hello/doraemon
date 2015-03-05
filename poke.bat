@echo off
cls
SET PWD=%~dp0
SET TEMPDIR=%PWD%cached/%TARG%\
SET JLINK=%PWD%JLinkWin/JLink.exe

%JLINK% -device nrf51422 -if swd -speed 2000

