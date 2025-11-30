kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO fallahn/tmxlite
    REF "v${VERSION}"
    HEAD_REF master
    SHA512 0ffe0505329f00ef9872998673a7c220a9a5352f830688ef17952c0c4f001e0c2994a3a28f0e7de60cc82fff2701561cccbc2143fd51984bf4870e7d1fd0a2ba
    PATCHES
        dependencies.patch
)

string(COMPARE EQUAL "${KMPKG_LIBRARY_LINKAGE}" "static" TMXLITE_STATIC_LIB)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/tmxlite"
    OPTIONS
        -DTMXLITE_STATIC_LIB=${TMXLITE_STATIC_LIB}
        -DUSE_EXTLIBS=ON
        -DPKGCONF_REQ_PUB=pugixml
)

kmpkg_cmake_install()

kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()

set(STATIC_POSTFIX "")
if(TMXLITE_STATIC_LIB)
    set(STATIC_POSTFIX "-s")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/tmxlite.pc" "-ltmxlite" "-ltmxlite${STATIC_POSTFIX}")
endif()

if(NOT KMPKG_BUILD_TYPE)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/tmxlite.pc" "-ltmxlite" "-ltmxlite${STATIC_POSTFIX}-d")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
