@echo off
echo Building Debug configuration...
cmake -B build-debug -DCMAKE_BUILD_TYPE=Debug
if errorlevel 1 exit /b %errorlevel%
cmake --build build-debug --config Debug
if errorlevel 1 exit /b %errorlevel%
echo.
echo Debug build complete.
