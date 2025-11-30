kmpkg_list(SET PATCHES)

if (KMPKG_TARGET_IS_ANDROID OR KMPKG_TARGET_IS_MINGW)
    kmpkg_list(APPEND PATCHES "enable-asm.diff")
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dbry/WavPack
    REF ${VERSION}
    SHA512 bf833a4470625291a00022ae1a04ed1c6572a34c11b096bf3f4136066c77fde55c82994e8a3cee553c216539b7fdac996de9d97a5ddb7aed4904fee04d0df443
    PATCHES ${PATCHES}
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DWAVPACK_INSTALL_DOCS=OFF
        -DWAVPACK_BUILD_PROGRAMS=OFF
        -DWAVPACK_BUILD_COOLEDIT_PLUGIN=OFF
        -DWAVPACK_BUILD_WINAMP_PLUGIN=OFF
        -DBUILD_TESTING=OFF
)

kmpkg_cmake_install()

if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_cmake_config_fixup(CONFIG_PATH cmake)
else()
    kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/WavPack)
endif()

kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/license.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)

if(KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW)
    if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
        if(NOT DEFINED KMPKG_BUILD_TYPE OR KMPKG_BUILD_TYPE STREQUAL "release")
            kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/wavpack.pc" "-lwavpack" "-lwavpackdll")
        endif()
        if(NOT DEFINED KMPKG_BUILD_TYPE OR KMPKG_BUILD_TYPE STREQUAL "debug")
            kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/wavpack.pc" "-lwavpack" "-lwavpackdll")
        endif()
    endif()
endif()

kmpkg_fixup_pkgconfig()
