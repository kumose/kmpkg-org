kmpkg_download_distfile(ARCHIVE
    URLS
        "https://ftpmirror.gnu.org/libmicrohttpd/libmicrohttpd-${VERSION}.tar.gz"
        "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-${VERSION}.tar.gz"
    FILENAME "libmicrohttpd-${VERSION}.tar.gz"
    SHA512 7092f307a00ba04b539be79a7c94ddf9b4b6e43343a66da49c6602fa860f77cf7f9017d7e40f9b7400d85a828a503248eb12dd121413aad68133003a20bb2c4a
)

kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
    PATCHES remove_pdb_install.patch
)

if(KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW)
    if (KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
        set(CFG_SUFFIX "dll")
    else()
        set(CFG_SUFFIX "static")
    endif()

    kmpkg_msbuild_install(
        SOURCE_PATH "${SOURCE_PATH}"
        PROJECT_SUBPATH w32/VS-Any-Version/libmicrohttpd.vcxproj
        RELEASE_CONFIGURATION "Release-${CFG_SUFFIX}"
        DEBUG_CONFIGURATION "Debug-${CFG_SUFFIX}"
    )
    
    file(GLOB MICROHTTPD_HEADERS "${SOURCE_PATH}/src/include/microhttpd.h")
    file(COPY ${MICROHTTPD_HEADERS} DESTINATION "${CURRENT_PACKAGES_DIR}/include")
else()
    kmpkg_list(SET config_args)
    if(KMPKG_TARGET_IS_OSX AND KMPKG_LIBRARY_LINKAGE STREQUAL "static")
        set(ENV{LIBS} "$ENV{LIBS} -framework Foundation -framework AppKit") # TODO: Get this from the extracted cmake vars somehow
    endif()
    if("https" IN_LIST FEATURES)
        kmpkg_list(APPEND config_args "--enable-https")
    else()
        kmpkg_list(APPEND config_args "--disable-https")
    endif()

    kmpkg_make_configure(
        SOURCE_PATH "${SOURCE_PATH}"
        AUTORECONF
        OPTIONS
            --disable-doc
            --disable-examples
            --disable-curl
            --disable-tools
            ${config_args}
        OPTIONS_DEBUG --enable-asserts
        OPTIONS_RELEASE --disable-asserts
    )

    kmpkg_make_install()
    kmpkg_fixup_pkgconfig()
    
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
