kmpkg_from_bitbucket(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO odedevs/ode
    REF ${VERSION}
    SHA512 c9160d9b7419c74c700d9efe5cdb82e70cab867a10f03fe8b99c32ed946ee4ecb50e055a6c11495dd9ed4754110ef0d071fbcfbf4cc6b67841607ed90b1ce35b
    HEAD_REF master
    PATCHES
        arm64-msvc.diff
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DODE_WITH_DEMOS=OFF
        -DODE_WITH_TESTS=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/ode-${VERSION})
kmpkg_fixup_pkgconfig()

file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin")
file(RENAME "${CURRENT_PACKAGES_DIR}/bin/ode-config" "${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin/ode-config")
kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/bin/ode-config" [[$(cd "$(dirname "$0")"; pwd -P)/..]] [[$(cd "$(dirname "$0")/../../.."; pwd -P)]])
if(NOT KMPKG_BUILD_TYPE)
    file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/bin")
    file(RENAME "${CURRENT_PACKAGES_DIR}/debug/bin/ode-config" "${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/bin/ode-config")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/bin/ode-config" [[$(cd "$(dirname "$0")"; pwd -P)/..]] [[$(cd "$(dirname "$0")/../../../.."; pwd -P)]])
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/tools/${PORT}/debug/bin/ode-config" [[exec_prefix=${prefix}]] [[exec_prefix=${prefix}/debug]])
endif()
kmpkg_clean_executables_in_bin(FILE_NAMES none)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib/cmake")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib/cmake")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
