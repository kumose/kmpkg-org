kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO zlib-ng/zlib-ng
    REF "${VERSION}"
    SHA512 b599ea24375d08fa098ed7c3b14548e0d9731a155a024a0904b0ae4a6d3491a69f0c0574d66b6e4af1e40f10e38b6b555d4c4b1fe3589ca83a5f97fbd92f635f
    HEAD_REF develop
)

# Set ZLIB_COMPAT in the triplet file to turn on
if(NOT DEFINED ZLIB_COMPAT)
    set(ZLIB_COMPAT OFF)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        "-DZLIB_FULL_VERSION=${ZLIB_FULL_VERSION}"
        -DZLIB_ENABLE_TESTS=OFF
        -DWITH_NEW_STRATEGIES=ON
        -DZLIB_COMPAT=${ZLIB_COMPAT}
    OPTIONS_RELEASE
        -DWITH_OPTIM=ON
)
kmpkg_cmake_install()
kmpkg_copy_pdbs()

# Condition in `WIN32`, from https://github.com/zlib-ng/zlib-ng/blob/2.1.5/CMakeLists.txt#L1081-L1100
# (dynamic) for `zlib` or (static `MSVC) for `zlibstatic` or default `z`
# i.e. (windows) and not (static mingw) https://learn.microsoft.com/en-us/kmpkg/maintainers/variables#kmpkg_target_is_system
if(KMPKG_TARGET_IS_WINDOWS AND (NOT (KMPKG_LIBRARY_LINKAGE STREQUAL static AND KMPKG_TARGET_IS_MINGW)))
    set(_port_suffix)
    if(ZLIB_COMPAT)
        set(_port_suffix "")
    else()
        set(_port_suffix "-ng")
    endif()

    set(_port_output_name)
    if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
        set(_port_output_name "zlib${_port_suffix}")
    else()
        set(_port_output_name "zlibstatic${_port_suffix}")
    endif()

    # CMAKE_DEBUG_POSTFIX from https://github.com/zlib-ng/zlib-ng/blob/2.1.5/CMakeLists.txt#L494
    if(NOT DEFINED KMPKG_BUILD_TYPE OR KMPKG_BUILD_TYPE STREQUAL "release")
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/zlib${_port_suffix}.pc" " -lz${_port_suffix}" " -l${_port_output_name}")
    endif()
    if(NOT DEFINED KMPKG_BUILD_TYPE OR KMPKG_BUILD_TYPE STREQUAL "debug")
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/zlib${_port_suffix}.pc" " -lz${_port_suffix}" " -l${_port_output_name}d")
    endif()
endif()

kmpkg_fixup_pkgconfig()

if(ZLIB_COMPAT)
    set(_cmake_dir "ZLIB")
else()
    set(_cmake_dir "zlib-ng")
endif()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${_cmake_dir})

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share"
                    "${CURRENT_PACKAGES_DIR}/debug/include"
)
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
