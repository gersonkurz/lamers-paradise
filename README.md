# lamers-paradise

A properly-scoped CMake wrapper for LAME 3.100 MP3 encoder. 

## Overview

This repository provides a clean CMake build system for the LAME MP3 encoder library. It wraps the official LAME 3.100 source code and produces a static library (`mp3lame-static`) that can be easily integrated into CMake projects via FetchContent.

## Motivation

Existing CMake wrappers for LAME (such as `cmake-lame`) use global `add_compile_definitions()` which pollutes the preprocessor namespace and leaks definitions into other targets. This breaks projects like JUCE that bundle their own libraries with conflicting definitions.

**lamers-paradise** solves this by using only target-scoped definitions:
- All `target_compile_definitions()` use `PRIVATE` scope
- No global `add_compile_definitions()` calls
- Clean namespace isolation for FetchContent consumers

## Supported Platforms

| Platform | Architectures |
|----------|---------------|
| Windows  | x64, x86, ARM64 |
| macOS    | ARM64 (Apple Silicon), x64 (Intel) |
| Linux    | Native architecture |

## Building

### Prerequisites

- CMake 3.16 or later
- Windows: Visual Studio 2019 or later (MSVC)
- macOS: Xcode Command Line Tools (Clang)
- Linux: GCC or Clang

### Windows

Using batch scripts (no additional tools needed):

```cmd
:: Build for specific architecture
build-x64.cmd
build-x86.cmd
build-arm64.cmd

:: Build all architectures (release)
publish.cmd

:: Clean build directories
clean.cmd
```

Using [just](https://github.com/casey/just) (if installed):

```cmd
just build-x64
just build-x86
just build-arm64
just publish
just clean
```

Using CMake directly:

```cmd
:: x64
cmake -B build-x64 -A x64
cmake --build build-x64 --config Release

:: x86
cmake -B build-x86 -A Win32
cmake --build build-x86 --config Release

:: ARM64
cmake -B build-arm64 -A ARM64
cmake --build build-arm64 --config Release
```

### macOS

Using [just](https://github.com/casey/just):

```bash
just build-arm64      # Apple Silicon (M1/M2/M3/M4)
just build-x64        # Intel
just build-universal  # Universal binary (both architectures)
just publish          # Build ARM64 + x64
just clean
```

Using CMake directly:

```bash
# ARM64 (Apple Silicon)
cmake -B build-arm64 -DCMAKE_OSX_ARCHITECTURES=arm64
cmake --build build-arm64 --config Release

# x64 (Intel)
cmake -B build-x64 -DCMAKE_OSX_ARCHITECTURES=x86_64
cmake --build build-x64 --config Release

# Universal binary
cmake -B build-universal -DCMAKE_OSX_ARCHITECTURES="arm64;x86_64"
cmake --build build-universal --config Release
```

### Linux

```bash
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

### Output Locations

Libraries are placed in architecture-specific directories:

| Platform | Output Path |
|----------|-------------|
| Windows x64 | `build-x64/lib/x64/Release/mp3lame-static.lib` |
| Windows x86 | `build-x86/lib/x86/Release/mp3lame-static.lib` |
| Windows ARM64 | `build-arm64/lib/arm64/Release/mp3lame-static.lib` |
| macOS ARM64 | `build-arm64/lib/arm64/libmp3lame-static.a` |
| macOS x64 | `build-x64/lib/x64/libmp3lame-static.a` |
| Linux | `build/lib/<arch>/libmp3lame-static.a` |

## Usage with FetchContent

The recommended way to use this library in your CMake project:

```cmake
include(FetchContent)

FetchContent_Declare(
    lame
    GIT_REPOSITORY https://github.com/gersonkurz/lamers-paradise.git
    GIT_TAG v3.100.1
    GIT_SHALLOW TRUE
)
FetchContent_MakeAvailable(lame)

# Link to your target
target_link_libraries(your_target PRIVATE mp3lame-static)

# Or use the namespaced alias
target_link_libraries(your_target PRIVATE lamers::mp3lame)
```

## Usage Example

```c
#include <lame/lame.h>
#include <stdio.h>

int main() {
    lame_global_flags* gfp = lame_init();
    if (gfp) {
        printf("LAME version: %s\n", get_lame_version());
        lame_close(gfp);
        return 0;
    }
    return 1;
}
```

## License

LGPL-2.0 (same as LAME)

## Credits

LAME is developed by The LAME Project. This repository is just a CMake wrapper around the official source code.

- Official LAME website: https://lame.sourceforge.io/
- LAME on SourceForge: https://sourceforge.net/projects/lame/
