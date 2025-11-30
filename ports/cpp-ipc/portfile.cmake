kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mutouyun/cpp-ipc
    REF 035d76d5aaaa420a61d5e08be841cc20e585adde #v1.3.0
    SHA512 fea7054befc143ca1b4c55f3ffb72eb81353ce08f761e7c1ca79dd016449f76fbfc19bdb046a68e4d84df0f24da0312a0f560d9a25257811689041267bb42f1a
    HEAD_REF master
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" LIBIPC_BUILD_SHARED_LIBS)
string(COMPARE EQUAL "${KMPKG_CRT_LINKAGE}" "static" LIBIPC_USE_STATIC_CRT)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DLIBIPC_BUILD_SHARED_LIBS:BOOL=${LIBIPC_BUILD_SHARED_LIBS}
        -DLIBIPC_USE_STATIC_CRT:BOOL=${LIBIPC_USE_STATIC_CRT}
        -DLIBIPC_BUILD_TESTS:BOOL=OFF
        -DLIBIPC_BUILD_DEMOS:BOOL=OFF
)

kmpkg_cmake_install()

if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/cpp-ipc")
    kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/cpp-ipc)
elseif(EXISTS "${CURRENT_PACKAGES_DIR}/share/cpp-ipc")
    kmpkg_cmake_config_fixup(CONFIG_PATH share/cpp-ipc)
endif()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/libipc/export.h" "#elif defined(LIBIPC_LIBRARY_SHARED_USING__)" "#elif 1")
endif()

kmpkg_copy_pdbs()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
