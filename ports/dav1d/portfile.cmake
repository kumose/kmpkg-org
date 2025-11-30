kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO videolan/dav1d
    REF "${VERSION}"
    SHA512 96973b59b367bc98fbc8b6c4f871259d9635caf487da86d7f5a4c42715424faf937e7e3f142a3175a7b473c3e945decb03a23e7a854b7c0ff0d11eeb5b692fad
    HEAD_REF master
)

if (KMPKG_TARGET_ARCHITECTURE STREQUAL "x86" OR KMPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    kmpkg_find_acquire_program(NASM)
    get_filename_component(NASM_EXE_PATH ${NASM} DIRECTORY)
    kmpkg_add_to_path(${NASM_EXE_PATH})
elseif (KMPKG_TARGET_IS_WINDOWS)
    kmpkg_find_acquire_program(GASPREPROCESSOR)
    foreach(GAS_PATH ${GASPREPROCESSOR})
        get_filename_component(GAS_ITEM_PATH ${GAS_PATH} DIRECTORY)
        kmpkg_add_to_path(${GAS_ITEM_PATH})
    endforeach(GAS_PATH)
endif()

set(LIBRARY_TYPE ${KMPKG_LIBRARY_LINKAGE})
if (LIBRARY_TYPE STREQUAL "dynamic")
    set(LIBRARY_TYPE "shared")
endif(LIBRARY_TYPE STREQUAL "dynamic")

kmpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        --default-library=${LIBRARY_TYPE}
        -Denable_tests=false
        -Denable_tools=false
)

kmpkg_install_meson()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
