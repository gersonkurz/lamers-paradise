@echo off
echo Building for Windows x64...
cmake -B build-x64 -A x64
if errorlevel 1 exit /b %errorlevel%
cmake --build build-x64 --config Release
if errorlevel 1 exit /b %errorlevel%
echo.
echo Build complete: build-x64\lib\x64\Release\mp3lame-static.lib
