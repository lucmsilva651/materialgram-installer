@echo off
chcp 65001 > nul

echo Removing old installs of materialgram...
rmdir /q /s %LOCALAPPDATA%\materialgram
rmdir /q /s %LOCALAPPDATA%\NirCmd
cls

echo Gathering latest release from GitHub API...
for /f "tokens=*" %%i in ('curl -s https://api.github.com/repos/kukuruzka165/materialgram/releases/latest ^| findstr "browser_download_url.*win64_materialgram"') do (
    set downloadUrl=%%i
)
setlocal
set downloadUrl=%downloadUrl:"=%
set downloadUrl=%downloadUrl:browser_download_url:=%
set downloadUrl=%downloadUrl: ,=%

echo Downloading from GitHub...
curl -L %downloadUrl% -o %LOCALAPPDATA%\materialgram.zip

echo Extracting from ZIP...
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%LOCALAPPDATA%\materialgram.zip', '%LOCALAPPDATA%\materialgram'); }"

echo Downloading NirCmd to do shortcuts...
powershell -nologo -noprofile -command "curl https://www.nirsoft.net/utils/nircmd-x64.zip -o %LOCALAPPDATA%\NirCmd.zip"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%LOCALAPPDATA%\NirCmd.zip', '%LOCALAPPDATA%\NirCmd'); }"

echo Doing shortcuts...
%LOCALAPPDATA%\NirCmd\nircmd.exe shortcut "%LOCALAPPDATA%\materialgram\materialgram.exe" "~$folder.programs$" "materialgram"
%LOCALAPPDATA%\NirCmd\nircmd.exe shortcut "%LOCALAPPDATA%\materialgram\materialgram.exe" "~$folder.desktop$" "materialgram"

echo Removing temp file...
del /f "%LOCALAPPDATA%\NirCmd.zip"
del /f "%LOCALAPPDATA%\materialgram.zip"
rmdir /q /s %LOCALAPPDATA%\NirCmd

echo Starting materialgram...
start %LOCALAPPDATA%\materialgram\materialgram.exe
exit
