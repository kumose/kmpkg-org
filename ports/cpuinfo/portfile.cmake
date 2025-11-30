# On Windows, we can get a cpuinfo.dll, but it exports no symbols.
if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO pytorch/cpuinfo
    REF 877328f188a3c7d1fa855871a278eb48d530c4c0
    SHA512 b6d5a9ce9996eee3b2f09f39115f7ae178fe4d4814cc35b049a59d04a82228e268aa52d073c307ccb56a427428622940e1c77f004c99851dfca0d3a5d803658b
    HEAD_REF master
    PATCHES
        add-clog-cmake.patch
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools CPUINFO_BUILD_TOOLS
        clog CPUINFO_BUILD_CLOG
)

set(LINK_OPTIONS "")
if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    list(APPEND LINK_OPTIONS -DCPUINFO_LIBRARY_TYPE=shared)
else()
    list(APPEND LINK_OPTIONS -DCPUINFO_LIBRARY_TYPE=static)
endif()

if(KMPKG_CRT_LINKAGE STREQUAL "dynamic")
    list(APPEND LINK_OPTIONS -DCPUINFO_RUNTIME_TYPE=shared)
else()
    list(APPEND LINK_OPTIONS -DCPUINFO_RUNTIME_TYPE=static)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        ${LINK_OPTIONS}
        -DCPUINFO_BUILD_UNIT_TESTS=OFF
        -DCPUINFO_BUILD_MOCK_TESTS=OFF
        -DCPUINFO_BUILD_BENCHMARKS=OFF
        -DCLOG_BUILD_TESTS=OFF
    OPTIONS_DEBUG
        -DCPUINFO_LOG_LEVEL=debug
    OPTIONS_RELEASE
        -DCPUINFO_LOG_LEVEL=default
    MAYBE_UNUSED_VARIABLES
        CLOG_BUILD_TESTS
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig() # pkg_check_modules(libcpuinfo)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

if("tools" IN_LIST FEATURES)
    set(additional_tools "")
    if(EXISTS "${CURRENT_PACKAGES_DIR}/bin/cpuid-dump${KMPKG_TARGET_EXECUTABLE_SUFFIX}")
        list(APPEND additional_tools "cpuid-dump")
    endif()
    kmpkg_copy_tools(
        TOOL_NAMES cache-info cpu-info isa-info ${additional_tools}
        AUTO_CLEAN
    )
endif()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
