kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO PortMidi/portmidi
    REF "v${VERSION}"
    SHA512 00d7cec97b58c074d484793b6097f4e60d061a9d680940bbcdb6670b287b78dbc099af378fb2e066c61f1c26e5060ded9c8f78c80fc03518b33e43f830e34a27 
    HEAD_REF master
    PATCHES    
        "android-support.patch"
)

if(KMPKG_CRT_LINKAGE STREQUAL static)
    set(PM_USE_STATIC_RUNTIME ON)
else()
    set(PM_USE_STATIC_RUNTIME OFF)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DPM_USE_STATIC_RUNTIME="${PM_USE_STATIC_RUNTIME}"
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/PortMidi)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CURRENT_PORT_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/license.txt")
