kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO OpenMPT/openmpt
    REF "libopenmpt-${VERSION}"
    SHA512 a82cc543074c5688a8a02d6bcbc378204c1962c1f4a44b9399b3cc708b4d0f660498bf496c446dd5a6dce48110e78eb2754a1454c451bb22de6664f18a8ddbc1
    HEAD_REF master
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        "-DVERSION=${VERSION}"
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup()
kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    kmpkg_replace_string(${CURRENT_PACKAGES_DIR}/include/libopenmpt/libopenmpt_config.h "defined(LIBOPENMPT_USE_DLL)" "0")
else()
    kmpkg_replace_string(${CURRENT_PACKAGES_DIR}/include/libopenmpt/libopenmpt_config.h "defined(LIBOPENMPT_USE_DLL)" "1")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
