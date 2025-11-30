kmpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO sammycage/lunasvg
  REF "v${VERSION}"
  SHA512 62cf1433f4d158008ab07c9b6a83dca2322e1adf97a7f30a2021be5610af7b28e2ed54c75292fb382a3dcc6205f0e7b8d815b8a59aa11843a059883203d191c1
  HEAD_REF master
)

kmpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
    -DCMAKE_REQUIRE_FIND_PACKAGE_plutovg=1
    -DUSE_SYSTEM_PLUTOVG=ON
    -DLUNASVG_BUILD_EXAMPLES=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/lunasvg)
kmpkg_fixup_pkgconfig()

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
  kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/lunasvg/lunasvg.h" "defined(LUNASVG_BUILD_STATIC)" "1")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
