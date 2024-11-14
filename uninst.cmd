@echo off
chcp 65001 > nul

echo Uninstalling materialgram and temp files...
rmdir /q /s %LOCALAPPDATA%\materialgram
rmdir /q /s %LOCALAPPDATA%\NirCmd

echo Removing shortcuts...
del /f "%APPDATA%\Roaming\Microsoft\Windows\Start Menu\Programs\materialgram.lnk"
del /f "%USERPROFILE%\Desktop\materialgram.lnk"