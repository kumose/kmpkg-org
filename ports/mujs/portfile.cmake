if(KMPKG_TARGET_IS_WINDOWS)
  kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  GITHUB_HOST https://codeberg.org
  REPO ccxvii/mujs
  REF "${VERSION}"
  SHA512 b553c09f2994b54ef6aa48ece3e6f8355ea69c6ec9ee2ea101fd33b3054dd6b57482c923c063929b3f108a5244ab51ffbd807d5a1d0f3f4ed4f40896ac97ab87
  HEAD_REF master
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")
file(COPY "${CMAKE_CURRENT_LIST_DIR}/mujs.pc" DESTINATION "${SOURCE_PATH}")

kmpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
    "-DPACKAGE_VERSION=${VERSION}"
  OPTIONS_DEBUG
    -DDISABLE_INSTALL_HEADERS=ON
)

kmpkg_cmake_install()
kmpkg_fixup_pkgconfig()
kmpkg_cmake_config_fixup(PACKAGE_NAME unofficial-mujs)
kmpkg_copy_pdbs()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
