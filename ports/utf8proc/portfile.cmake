kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO JuliaLang/utf8proc
    REF v${VERSION}
    SHA512 01796ffd1b253c4943af8c084f60b3fed3ef469a25f017fdb5cdb430fff901741dd06186c938c4559e9f03bbc376d3e90fcf36eba93f9c6febff3be9cc38fdae
)

kmpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DUTF8PROC_ENABLE_TESTING=OFF
        -DUTF8PROC_INSTALL=ON
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/utf8proc)
kmpkg_fixup_pkgconfig()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/utf8proc.h" "#ifdef UTF8PROC_STATIC" "#if 1 /* UTF8PROC_STATIC */")
    if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/utf8proc_static.lib")
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/libutf8proc.pc" " -lutf8proc" " -lutf8proc_static")
        if(NOT KMPKG_BUILD_TYPE)
            kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/libutf8proc.pc" " -lutf8proc" " -lutf8proc_static")
        endif()
    endif()
endif()

# Legacy
file(INSTALL "${CURRENT_PORT_DIR}/unofficial-utf8proc-config.cmake" DESTINATION "${CURRENT_PACKAGES_DIR}/share/unofficial-utf8proc")

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
