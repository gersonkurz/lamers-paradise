@echo off
echo Building all Windows architectures (Release)...
echo.

echo [1/3] Building x64...
call "%~dp0build-x64.cmd"
if errorlevel 1 (
    echo ERROR: x64 build failed
    exit /b %errorlevel%
)
echo.

echo [2/3] Building x86...
call "%~dp0build-x86.cmd"
if errorlevel 1 (
    echo ERROR: x86 build failed
    exit /b %errorlevel%
)
echo.

echo [3/3] Building ARM64...
call "%~dp0build-arm64.cmd"
if errorlevel 1 (
    echo ERROR: ARM64 build failed
    exit /b %errorlevel%
)
echo.

echo ============================================
echo All Windows release builds complete:
echo   - build-x64\lib\x64\Release\mp3lame-static.lib
echo   - build-x86\lib\x86\Release\mp3lame-static.lib
echo   - build-arm64\lib\arm64\Release\mp3lame-static.lib
echo ============================================
