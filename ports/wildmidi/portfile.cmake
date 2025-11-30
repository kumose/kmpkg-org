kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Mindwerks/wildmidi
    REF "wildmidi-${VERSION}"
    SHA512 b7259578c1b334de13b49e27aef32ad43e41bc04f569601b765ecea789b8da536d07afdb581986b7c91de552db2a625b13d061e52a2c8c51652f3cf3d1a30000
    HEAD_REF master
    PATCHES
        fix-include-path.patch
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" WANT_STATIC)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DWANT_PLAYER=OFF
        -DWANT_STATIC=${WANT_STATIC}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME WildMidi CONFIG_PATH lib/cmake/WildMidi)
kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()

if(KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW)
    string(REPLACE "-dynamic" "" lib_suffix "-${KMPKG_LIBRARY_LINKAGE}")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/wildmidi.pc" " -lWildMidi" " -llibWildMidi${lib_suffix}")
    if(NOT KMPKG_BUILD_TYPE)
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/wildmidi.pc" " -lWildMidi" " -llibWildMidi${lib_suffix}")
    endif()
endif()

if(WANT_STATIC)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/wildmidi_lib.h" "defined(WILDMIDI_STATIC)" "1")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/man")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/docs/license/LGPLv3.txt")
