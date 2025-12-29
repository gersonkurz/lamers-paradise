/* config.h for cross-platform builds (Windows/macOS/Linux) */
#ifndef LAME_CONFIG_H
#define LAME_CONFIG_H

/* The number of bytes in a double.  */
#define SIZEOF_DOUBLE 8

/* The number of bytes in a float.  */
#define SIZEOF_FLOAT 4

/* The number of bytes in a int.  */
#define SIZEOF_INT 4

/* The number of bytes in a long.  */
#ifdef _WIN32
#define SIZEOF_LONG 4
#else
/* On 64-bit Unix/macOS, long is 8 bytes */
#if defined(__LP64__) || defined(_LP64)
#define SIZEOF_LONG 8
#else
#define SIZEOF_LONG 4
#endif
#endif

/* The number of bytes in a long double.  */
#define SIZEOF_LONG_DOUBLE 16

/* The number of bytes in a short.  */
#define SIZEOF_SHORT 2

/* The number of bytes in a unsigned int.  */
#define SIZEOF_UNSIGNED_INT 4

/* The number of bytes in a unsigned long.  */
#ifdef _WIN32
#define SIZEOF_UNSIGNED_LONG 4
#else
#if defined(__LP64__) || defined(_LP64)
#define SIZEOF_UNSIGNED_LONG 8
#else
#define SIZEOF_UNSIGNED_LONG 4
#endif
#endif

/* The number of bytes in a unsigned short.  */
#define SIZEOF_UNSIGNED_SHORT 2

/* Define if you have the ANSI C header files.  */
#define STDC_HEADERS 1

/* Define if you have the <errno.h> header file.  */
#define HAVE_ERRNO_H 1

/* Define if you have the <fcntl.h> header file.  */
#define HAVE_FCNTL_H 1

/* Define if you have the <limits.h> header file.  */
#define HAVE_LIMITS_H 1

/* Define if you have the <stdint.h> header file.  */
#define HAVE_STDINT_H 1

/* Define if you have the <inttypes.h> header file.  */
#ifndef _WIN32
#define HAVE_INTTYPES_H 1
#endif

/* Package info */
#define PACKAGE "lame"
#define VERSION "3.100"

/* Define if compiler has function prototypes */
#define PROTOTYPES 1

/* faster log implementation with less but enough precision */
#define USE_FAST_LOG 1

#define HAVE_STRCHR 1
#define HAVE_MEMCPY 1

/* IEEE754 hack for faster float-to-int conversion */
#define TAKEHIRO_IEEE754_HACK 1

/* Use Layer 2 decoding */
#define USE_LAYER_2 1

/* MPGLIB for decoding */
#define HAVE_MPGLIB 1

#ifdef HAVE_MPGLIB
#define DECODE_ON_THE_FLY 1
#endif

/* Type definitions */
#if defined(_MSC_VER)
/* Windows MSVC */
#pragma warning( disable : 4305 )
#if _MSC_VER >= 1600
#include <stdint.h>
#else
typedef __int8  int8_t;
typedef __int16 int16_t;
typedef __int32 int32_t;
typedef __int64 int64_t;
typedef unsigned __int8  uint8_t;
typedef unsigned __int16 uint16_t;
typedef unsigned __int32 uint32_t;
typedef unsigned __int64 uint64_t;
#endif
typedef float  float32_t;
typedef double float64_t;
#if _MSC_VER < 1900
#define inline __inline
#endif
#else
/* GCC/Clang (macOS, Linux) */
#include <stdint.h>
#include <inttypes.h>
typedef float  float32_t;
typedef double float64_t;
#endif

/* IEEE754 float types */
typedef long double ieee854_float80_t;
typedef double      ieee754_float64_t;
typedef float       ieee754_float32_t;

#define LAME_LIBRARY_BUILD

/* SSE/SIMD support - only define for x86/x64 architectures */
#if (defined(__i386__) || defined(__x86_64__) || defined(_M_IX86) || defined(_M_X64)) && !defined(HAVE_XMMINTRIN_H)
#define HAVE_XMMINTRIN_H
#endif

#endif /* LAME_CONFIG_H */
