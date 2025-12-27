# lamers-paradise build recipes
# Cross-platform builds for LAME 3.100 CMake wrapper

# Default recipe - show available commands
default:
    @just --list

# ============================================================================
# Windows builds (MSVC)
# ============================================================================

# Build for Windows x64
[windows]
build-x64:
    cmake -B build-x64 -A x64
    cmake --build build-x64 --config Release

# Build for Windows x86
[windows]
build-x86:
    cmake -B build-x86 -A Win32
    cmake --build build-x86 --config Release

# Build for Windows ARM64
[windows]
build-arm64:
    cmake -B build-arm64 -A ARM64
    cmake --build build-arm64 --config Release

# Build all Windows architectures (release)
[windows]
publish: build-x64 build-x86 build-arm64
    @echo "All Windows release builds complete:"
    @echo "  - build-x64/lib/x64/Release/mp3lame-static.lib"
    @echo "  - build-x86/lib/x86/Release/mp3lame-static.lib"
    @echo "  - build-arm64/lib/arm64/Release/mp3lame-static.lib"

# Clean all Windows build directories
[windows]
clean:
    -rmdir /s /q build-x64 2>nul
    -rmdir /s /q build-x86 2>nul
    -rmdir /s /q build-arm64 2>nul
    @echo "Cleaned all build directories"

# ============================================================================
# macOS builds (Clang)
# ============================================================================

# Build for macOS ARM64 (Apple Silicon - M1/M2/M3/M4)
[macos]
build-arm64:
    cmake -B build-arm64 -DCMAKE_OSX_ARCHITECTURES=arm64
    cmake --build build-arm64 --config Release

# Build for macOS x64 (Intel)
[macos]
build-x64:
    cmake -B build-x64 -DCMAKE_OSX_ARCHITECTURES=x86_64
    cmake --build build-x64 --config Release

# Build universal binary (both architectures)
[macos]
build-universal:
    cmake -B build-universal -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64"
    cmake --build build-universal --config Release

# Build all macOS architectures (release)
[macos]
publish: build-arm64 build-x64
    @echo "All macOS release builds complete:"
    @echo "  - build-arm64/lib/arm64/libmp3lame-static.a"
    @echo "  - build-x64/lib/x64/libmp3lame-static.a"

# Clean all macOS build directories
[macos]
clean:
    rm -rf build-arm64 build-x64 build-universal
    @echo "Cleaned all build directories"

# ============================================================================
# Linux builds (GCC/Clang)
# ============================================================================

# Build for Linux native architecture
[linux]
build:
    cmake -B build -DCMAKE_BUILD_TYPE=Release
    cmake --build build

# Build for Linux (alias for native)
[linux]
build-native: build

# Clean Linux build directory
[linux]
clean:
    rm -rf build
    @echo "Cleaned build directory"

# Linux publish (native only)
[linux]
publish: build
    @echo "Linux release build complete"

# ============================================================================
# Cross-platform recipes
# ============================================================================

# Configure only (no build) - useful for IDE integration
configure:
    cmake -B build

# Build debug configuration
build-debug:
    cmake -B build-debug -DCMAKE_BUILD_TYPE=Debug
    cmake --build build-debug
