kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO munt/munt
    REF libmt32emu_2_7_1
    SHA512 369d1c5f16b37f3d8544ad30a30c3aa9d0796f67fcf5988e789958bff14bba119f7c5fd4c43816eb369a14b56f22f0c7eb3016ff838cd36d1d6f22ed84a2e8b9
    HEAD_REF master
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/mt32emu"
    OPTIONS
        -Dlibmt32emu_SHARED:BOOL=${BUILD_SHARED}
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME MT32Emu CONFIG_PATH lib/cmake/MT32Emu)

kmpkg_fixup_pkgconfig()

kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/doc")


file(INSTALL "${SOURCE_PATH}/mt32emu/COPYING.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
