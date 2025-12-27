cmake_minimum_required(VERSION 3.16)
project(lamers-paradise VERSION 3.100.1 LANGUAGES C)

# Determine target architecture for output directory naming
if(CMAKE_GENERATOR_PLATFORM)
    # MSVC generator platform (Win32, x64, ARM64)
    string(TOLOWER "${CMAKE_GENERATOR_PLATFORM}" LAME_ARCH)
    if(LAME_ARCH STREQUAL "win32")
        set(LAME_ARCH "x86")
    endif()
elseif(CMAKE_SYSTEM_PROCESSOR)
    # Use system processor for other generators
    string(TOLOWER "${CMAKE_SYSTEM_PROCESSOR}" LAME_ARCH)
    if(LAME_ARCH MATCHES "amd64|x86_64")
        set(LAME_ARCH "x64")
    elseif(LAME_ARCH MATCHES "i[3-6]86|x86")
        set(LAME_ARCH "x86")
    elseif(LAME_ARCH MATCHES "arm64|aarch64")
        set(LAME_ARCH "arm64")
    elseif(LAME_ARCH MATCHES "arm")
        set(LAME_ARCH "arm")
    endif()
else()
    set(LAME_ARCH "unknown")
endif()

# Set output directories with architecture suffix
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/${LAME_ARCH})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/${LAME_ARCH})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/${LAME_ARCH})

# Collect source files
set(LIBMP3LAME_SOURCES
    lame-3.100/libmp3lame/bitstream.c
    lame-3.100/libmp3lame/encoder.c
    lame-3.100/libmp3lame/fft.c
    lame-3.100/libmp3lame/gain_analysis.c
    lame-3.100/libmp3lame/id3tag.c
    lame-3.100/libmp3lame/lame.c
    lame-3.100/libmp3lame/mpglib_interface.c
    lame-3.100/libmp3lame/newmdct.c
    lame-3.100/libmp3lame/presets.c
    lame-3.100/libmp3lame/psymodel.c
    lame-3.100/libmp3lame/quantize.c
    lame-3.100/libmp3lame/quantize_pvt.c
    lame-3.100/libmp3lame/reservoir.c
    lame-3.100/libmp3lame/set_get.c
    lame-3.100/libmp3lame/tables.c
    lame-3.100/libmp3lame/takehiro.c
    lame-3.100/libmp3lame/util.c
    lame-3.100/libmp3lame/vbrquantize.c
    lame-3.100/libmp3lame/VbrTag.c
    lame-3.100/libmp3lame/version.c
    lame-3.100/libmp3lame/vector/xmm_quantize_sub.c
)

set(MPGLIB_SOURCES
    lame-3.100/mpglib/common.c
    lame-3.100/mpglib/dct64_i386.c
    lame-3.100/mpglib/decode_i386.c
    lame-3.100/mpglib/interface.c
    lame-3.100/mpglib/layer1.c
    lame-3.100/mpglib/layer2.c
    lame-3.100/mpglib/layer3.c
    lame-3.100/mpglib/tabinit.c
)

# Create the static library
add_library(mp3lame-static STATIC
    ${LIBMP3LAME_SOURCES}
    ${MPGLIB_SOURCES}
)

# CRITICAL: Use target_compile_definitions with PRIVATE scope
# This prevents definitions from leaking to consumers
target_compile_definitions(mp3lame-static PRIVATE
    HAVE_MPGLIB
    HAVE_STDINT_H
    STDC_HEADERS
)

# Platform-specific definitions (all PRIVATE!)
if(WIN32)
    target_compile_definitions(mp3lame-static PRIVATE
        TAKEHIRO_IEEE754_HACK
        USE_LAYER_2
        HAVE_CONFIG_H
        _CRT_SECURE_NO_WARNINGS
        _CRT_SECURE_NO_DEPRECATE
    )
else()
    target_compile_definitions(mp3lame-static PRIVATE
        TAKEHIRO_IEEE754_HACK
        USE_LAYER_2
        HAVE_CONFIG_H
    )
endif()

# Include directories
# PRIVATE: for building the library itself
# PUBLIC: for consumers who link against the library (they need lame.h)
target_include_directories(mp3lame-static
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/lame-3.100/libmp3lame
        ${CMAKE_CURRENT_SOURCE_DIR}/lame-3.100/mpglib
        ${CMAKE_CURRENT_SOURCE_DIR}/lame-3.100
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/lame-3.100/include>
        $<INSTALL_INTERFACE:include>
)

# Alias for cleaner usage
add_library(lamers::mp3lame ALIAS mp3lame-static)

# Suppress warnings for third-party code
if(MSVC)
    target_compile_options(mp3lame-static PRIVATE /W0)
else()
    target_compile_options(mp3lame-static PRIVATE -w)
endif()

# Print configuration info
message(STATUS "lamers-paradise: Building for architecture: ${LAME_ARCH}")
message(STATUS "lamers-paradise: Output directory: ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
