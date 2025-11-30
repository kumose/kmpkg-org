kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDE/kdiagram
    REF v2.8.0
    SHA512 5a3b958aaf386b1cde3c840963521306ded5b1975cc293dbb36c60cacd52a62badaf64a6c5f3cd63fc65f02d0ba181d318496d665f08140299720cd022a855e7
    HEAD_REF master
)

# Prevent KDEClangFormat from writing to source effectively blocking parallel configure
file(WRITE ${SOURCE_PATH}/.clang-format "DisableFormat: true\nSortIncludes: false\n")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME KChart CONFIG_PATH lib/cmake/KChart DO_NOT_DELETE_PARENT_CONFIG_PATH)
kmpkg_cmake_config_fixup(PACKAGE_NAME KGantt CONFIG_PATH lib/cmake/KGantt)
kmpkg_copy_pdbs()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.GPL.txt")
