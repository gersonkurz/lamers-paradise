@echo off
echo Cleaning build directories...

if exist build-x64 (
    rmdir /s /q build-x64
    echo   Removed build-x64
)
if exist build-x86 (
    rmdir /s /q build-x86
    echo   Removed build-x86
)
if exist build-arm64 (
    rmdir /s /q build-arm64
    echo   Removed build-arm64
)
if exist build-debug (
    rmdir /s /q build-debug
    echo   Removed build-debug
)
if exist build (
    rmdir /s /q build
    echo   Removed build
)

echo Done.
