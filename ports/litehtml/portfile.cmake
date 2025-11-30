kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO litehtml/litehtml
    REF v0.9
    SHA512 2a156671b770a6a20ab00184d9869af779248dd1fb898930b3b479ee88d8b7d84f51fdbd689ae4124530ab70c8697b6641cf06b220631ce4fec4622e63845ea3
    PATCHES
      use-kmpkg-gumbo.patch
      fix-relative-includes.patch
)

if (KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DLITEHTML_BUILD_TESTING=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME litehtml CONFIG_PATH lib/cmake/litehtml)


file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
