@echo off
echo Building for Windows ARM64...
cmake -B build-arm64 -A ARM64
if errorlevel 1 exit /b %errorlevel%
cmake --build build-arm64 --config Release
if errorlevel 1 exit /b %errorlevel%
echo.
echo Build complete: build-arm64\lib\arm64\Release\mp3lame-static.lib
