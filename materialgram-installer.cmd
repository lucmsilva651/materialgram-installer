@echo off
chcp 65001

rmdir /q /s %LOCALAPPDATA%\materialgram
mkdir %LOCALAPPDATA%\materialgram
cd %LOCALAPPDATA%\materialgram

for /f "tokens=*" %%i in ('curl -s https://api.github.com/repos/kukuruzka165/materialgram/releases/latest ^| findstr "browser_download_url.*win64_materialgram"') do (
    set downloadUrl=%%i
)
setlocal
set downloadUrl=%downloadUrl:"=%
set downloadUrl=%downloadUrl:browser_download_url:=%
set downloadUrl=%downloadUrl: ,=%

curl -L %downloadUrl% -o latest.zip

set "zipFile=latest.zip"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%zipFile%', '%~dp0'); }"

cd %~dp0
move /y Materialgram.exe %LOCALAPPDATA%\materialgram\materialgram.exe
move /y Updater.exe %LOCALAPPDATA%\materialgram\updater.exe 

nircmd-x64\nircmd.exe shortcut "%LOCALAPPDATA%\materialgram\materialgram.exe" "~$folder.programs$" "materialgram"
nircmd-x64\nircmd.exe shortcut "%LOCALAPPDATA%\materialgram\materialgram.exe" "~$folder.desktop$" "materialgram"

del /f "%LOCALAPPDATA%\materialgram\latest.zip"

start %LOCALAPPDATA%\materialgram\materialgram.exe
exit
