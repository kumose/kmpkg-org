kmpkg_from_gitlab(
    GITLAB_URL https://code.videolan.org
    OUT_SOURCE_PATH SOURCE_PATH
    REPO videolan/libbluray
    REF ${VERSION}
    SHA512 e728f8d93b311d540a3883ba869fdc2c10e91b4009bf1796947b510d3646088dfd7aeabaebb3a1dcbf49d5afee48743bfa620fd93aa54bf948238510e7e7719f
    PATCHES
        msvc.diff
)

if(NOT KMPKG_TARGET_IS_WINDOWS)
    list(APPEND options -Dfontconfig=enabled)
else()
    list(APPEND options -Dfontconfig=disabled)
endif()

kmpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Denable_tools=false
        -Dbdj_jar=disabled
        -Dfreetype=enabled
        -Dlibxml2=enabled
        ${options}
)

kmpkg_install_meson()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
