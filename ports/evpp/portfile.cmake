if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Qihoo360/evpp
    REF v${VERSION}
    SHA512 ddcef8d2af6b3c46473d755c0f0994d63d56240ea85d6b44ceb6b77724c3c56bbf1156f7188e270fb5f9f36f25bfc2f96669d7249a34c921922671e3fe267e88
    HEAD_REF master
    PATCHES
        basic-fixes.diff
        dependencies.diff
        fix-rapidjson-1-1.patch
        fix-osx-build.patch
        Add-static-shared-handling.patch
        Export-unofficial-target.patch
)
file(REMOVE_RECURSE 
    "${SOURCE_PATH}/3rdparty/concurrentqueue"
    "${SOURCE_PATH}/3rdparty/gtest"
    "${SOURCE_PATH}/3rdparty/rapidjson"
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DEVPP_KMPKG_BUILD=ON
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME unofficial-evpp)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(
    FILE_LIST "${SOURCE_PATH}/LICENSE"
    COMMENT [[
The evpp source code is offered under the BSD-3-Clause license.
However, evpp includes 3rd-party source code with other licenses
and additional attribution requirements.
]])
