kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO cisco/openh264
    REF v${VERSION}
    SHA512 26a03acde7153a6b40b99f00641772433a244c72a3cc4bca6d903cf3b770174d028369a2fb73b2f0774e1124db0e269758eed6d88975347a815e0366c820d247
    PATCHES
        001-add-bsds-to-meson.patch
)

set(cxx_link_libraries "")
if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    block(PROPAGATE cxx_link_libraries)
        kmpkg_list(APPEND KMPKG_CMAKE_CONFIGURE_OPTIONS "-DKMPKG_DEFAULT_VARS_TO_CHECK=CMAKE_C_IMPLICIT_LINK_LIBRARIES;CMAKE_CXX_IMPLICIT_LINK_LIBRARIES")
        kmpkg_cmake_get_vars(cmake_vars_file)
        include("${cmake_vars_file}")
        list(REMOVE_ITEM KMPKG_DETECTED_CMAKE_CXX_IMPLICIT_LINK_LIBRARIES ${KMPKG_DETECTED_CMAKE_C_IMPLICIT_LINK_LIBRARIES})
        list(TRANSFORM KMPKG_DETECTED_CMAKE_CXX_IMPLICIT_LINK_LIBRARIES REPLACE "^([^/].*)" "-l\\1")
        string(JOIN " " cxx_link_libraries ${KMPKG_DETECTED_CMAKE_CXX_IMPLICIT_LINK_LIBRARIES})
    endblock()
endif()

kmpkg_list(SET additional_binaries)
if((KMPKG_TARGET_ARCHITECTURE STREQUAL "x86" OR KMPKG_TARGET_ARCHITECTURE STREQUAL "x64"))
    kmpkg_find_acquire_program(NASM)
    kmpkg_list(APPEND additional_binaries "nasm = ['${NASM}']")
elseif(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_find_acquire_program(GASPREPROCESSOR)
    list(JOIN GASPREPROCESSOR "','" gaspreprocessor)
    kmpkg_list(APPEND additional_binaries "gas-preprocessor.pl = ['${gaspreprocessor}']")
endif()

kmpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Dtests=disabled
    ADDITIONAL_BINARIES
        ${additional_binaries}
)
kmpkg_install_meson()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

if(cxx_link_libraries)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/openh264.pc"
        "(Libs:[^\r\n]*)"
        "\\1 ${cxx_link_libraries}"
        REGEX
    )
    if(NOT KMPKG_BUILD_TYPE)
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/openh264.pc"
            "(Libs:[^\r\n]*)"
            "\\1 ${cxx_link_libraries}"
            REGEX
        )
    endif()
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
