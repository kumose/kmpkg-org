if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO memononen/nanosvg
    REF 93ce879dc4c04a3ef1758428ec80083c38610b1f
    SHA512 14ecaf11efd2f0b983847ded557557a2919cc04fc5e9748118cc0bd33fccae2688afc0dc182ebb8c0deb4b599c697f140185644a087c702fba1e6368f5a5b89c
    HEAD_REF master
    PATCHES
        fltk.patch # from fltk/nanosvg
)

kmpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/NanoSVG)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
