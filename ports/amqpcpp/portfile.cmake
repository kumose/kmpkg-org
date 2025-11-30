kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO CopernicaMarketingSoftware/AMQP-CPP
    REF "v${VERSION}"
    SHA512 310e0d1bc1780d54bd1f9a99d114003aee7bdfe8930be198b3006f2ca174c32718844f88d72fd75259d6ce20d35a9dc77a61aea4c364e4af17ba8c87cae43259
    HEAD_REF master
    PATCHES
        fix-max_min_macros.patch
)

if(KMPKG_TARGET_IS_LINUX)
    set(LINUX_TCP ON)
else()
    set(LINUX_TCP OFF)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DAMQP-CPP_BUILD_SHARED=OFF
        -DAMQP-CPP_LINUX_TCP=${LINUX_TCP}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH cmake)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_fixup_pkgconfig()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
