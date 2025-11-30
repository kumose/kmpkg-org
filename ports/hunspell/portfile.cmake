kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO hunspell/hunspell
    REF "v${VERSION}"
    SHA512 d007edc8cb7ff95048361418b088bb062962973247c940aa826c9859a5ef90a9734100bffe7c7ac9a774f2e233605e814efb9e7fd3fc8c4ef4b978e9ec990cba
    HEAD_REF master
    PATCHES
        0005-autotools-subdirs.patch
)

file(REMOVE "${SOURCE_PATH}/README") #README is a symlink
configure_file("${SOURCE_PATH}/README.md" "${SOURCE_PATH}/README" COPYONLY)

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    set(KMPKG_C_FLAGS "${KMPKG_C_FLAGS} -DHUNSPELL_STATIC")
    set(KMPKG_CXX_FLAGS "${KMPKG_CXX_FLAGS} -DHUNSPELL_STATIC")
endif()

kmpkg_list(SET options)

if("tools" IN_LIST FEATURES)
    kmpkg_list(APPEND options "--enable-tools")
endif()

if("nls" IN_LIST FEATURES)
    kmpkg_list(APPEND options "--enable-nls")
else()
    set(ENV{AUTOPOINT} true) # true, the program
    kmpkg_list(APPEND options "--disable-nls")
endif()

kmpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
    ADDITIONAL_MSYS_PACKAGES gzip
    OPTIONS
        ${options}
    OPTIONS_DEBUG
        --disable-tools
)

if("nls" IN_LIST FEATURES)
    kmpkg_build_make(BUILD_TARGET dist LOGFILE_ROOT build-dist)
endif()

kmpkg_install_make()

kmpkg_copy_tool_dependencies("${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin")

kmpkg_fixup_pkgconfig()

set(HUNSPELL_EXPORT_HDR "${CURRENT_PACKAGES_DIR}/include/hunspell/hunvisapi.h")

if (KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    kmpkg_replace_string("${HUNSPELL_EXPORT_HDR}" "#if defined(HUNSPELL_STATIC)" "#if 1")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(
    COMMENT "Hunspell is licensed under LGPL/GPL/MPL tri-license."
    FILE_LIST
        "${SOURCE_PATH}/license.hunspell"
        "${SOURCE_PATH}/license.myspell"
        "${SOURCE_PATH}/COPYING.MPL"
        "${SOURCE_PATH}/COPYING"
        "${SOURCE_PATH}/COPYING.LESSER"
)
