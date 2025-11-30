kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO jedisct1/libhydrogen
    REF 9f9d504bb5a97bc98ee52529726d41c027df76ad #2022-06-21
    SHA512 f4dabc0b399c8850563c8a967209db537fdf787deaef46899a5484bc89bffb31581312940549784defe4c42d057309aaabd402831a7c3a94b04a00d47a07736c 
    HEAD_REF master
    PATCHES
        remove-tests.patch
        no-arch.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH share/cmake/hydrogen)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

configure_file("${SOURCE_PATH}/LICENSE" "${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright" COPYONLY)
