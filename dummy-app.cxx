#include <cassert>
#define _DUMMY_BUILD
#include "compat.h"
#include "plugin.h"

int main() {
    PluginInfo pi;
    assert(F4SEPlugin_Query(nullptr, &pi));
    assert(F4SEPlugin_Load(nullptr));
    return 0;
}