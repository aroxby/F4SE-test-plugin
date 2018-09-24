#ifndef _COMPAT_H_
#define _COMPAT_H_

// F4SE is missing these type definitions
// Perhaps they're standard in MSVC
#include <cstdint>
#include <stdint.h>
typedef uint32_t UInt32;
typedef uint64_t UInt64;

#endif//_COMPAT_H_