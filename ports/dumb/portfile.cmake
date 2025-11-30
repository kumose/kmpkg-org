if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO kode54/dumb
    REF "${VERSION}"
    SHA512 18b10a507d69a754cdf97fbeae41c17f211a6ba1f166a822276bdb6769d3edc326919067a3f4d1247d6715d7a5a8276669d83b9427e7336c6d111593fb7e36cf
    HEAD_REF master
    PATCHES
        "check-for-math-lib.patch"
        "do-not-overwrite-cflags.patch"
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_EXAMPLES=OFF
        -DBUILD_ALLEGRO4=OFF
)

kmpkg_cmake_install()
kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()

kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/dumb.pc" "-llibdumb" "-ldumb")
if(NOT KMPKG_BUILD_TYPE)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/dumb.pc" "-llibdumb" "-ldumbd")
endif()

if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/dumb.pc" " -lm" "")
    if(NOT KMPKG_BUILD_TYPE)
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/dumb.pc" " -lm" "")
    endif()
endif()

file(REMOVE_RECURSE 
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
