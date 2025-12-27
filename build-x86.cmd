@echo off
echo Building for Windows x86...
cmake -B build-x86 -A Win32
if errorlevel 1 exit /b %errorlevel%
cmake --build build-x86 --config Release
if errorlevel 1 exit /b %errorlevel%
echo.
echo Build complete: build-x86\lib\x86\Release\mp3lame-static.lib
