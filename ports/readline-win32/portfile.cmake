kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO xiaozhuai/readline-win32
    REF 0fa4001557c27157a51a9ca7f32a8c50bc97927a
    SHA512 5e6bb2fb077445d4e1fad49f2260538b0cf7e49857cda81640b8afd034324ad9b927c9ea00c9288d08c887478523db891bfc799e49ae009d32479141766857ec
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME unofficial-readline-win32)
kmpkg_fixup_pkgconfig()

if (KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/readline/rlstdc.h"
        "defined(USE_READLINE_STATIC)" "1"
    )
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share" "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_copy_pdbs()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
