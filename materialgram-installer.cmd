@echo off
chcp 65001

rmdir /q /s %LOCALAPPDATA%\Materialgram
mkdir %LOCALAPPDATA%\Materialgram
cd %LOCALAPPDATA%\Materialgram

for /f "tokens=*" %%i in ('curl -s https://api.github.com/repos/kukuruzka165/materialgram/releases/latest ^| findstr "browser_download_url.*win64_materialgram"') do (
    set downloadUrl=%%i
)
setlocal
set downloadUrl=%downloadUrl:"=%
set downloadUrl=%downloadUrl:browser_download_url:=%
set downloadUrl=%downloadUrl: ,=%

curl -L %downloadUrl% -o win64_materialgram_latest.zip

set "zipFile=win64_materialgram_latest.zip"
powershell -nologo -noprofile -command "& { Add-Type -A 'System.IO.Compression.FileSystem'; [IO.Compression.ZipFile]::ExtractToDirectory('%zipFile%', '%~dp0'); }"

cd %~dp0
move /y Materialgram.exe %LOCALAPPDATA%\Materialgram\Materialgram.exe
move /y Updater.exe %LOCALAPPDATA%\Materialgram\Updater.exe 

nircmd-x64\nircmd.exe shortcut "%LOCALAPPDATA%\Materialgram\Materialgram.exe" "~$folder.programs$" "Materialgram"
nircmd-x64\nircmd.exe shortcut "%LOCALAPPDATA%\Materialgram\Materialgram.exe" "~$folder.desktop$" "Materialgram"

del /f "%LOCALAPPDATA%\Materialgram\win64_materialgram_latest.zip"

start %LOCALAPPDATA%\Materialgram\Materialgram.exe
exit