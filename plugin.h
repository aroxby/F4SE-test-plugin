#ifndef _PLUGIN_H_
#define _PLUGIN_H_

// F4SE is missing these type definitions
// Perhaps they're standard in MSVC
#include <cstdint>
typedef uint32_t UInt32;
typedef uint64_t UInt64;

#include "f4se/PluginAPI.h"

#ifdef _DUMMY_BUILD
    #define DLLFUNC extern "C" __declspec(dllimport)
#else
    #define DLLFUNC extern "C" __declspec(dllexport)
#endif

DLLFUNC bool F4SEPlugin_Query(const F4SEInterface * f4se, PluginInfo * info);
DLLFUNC bool F4SEPlugin_Load(const F4SEInterface * f4se);

#endif//_PLUGIN_H_