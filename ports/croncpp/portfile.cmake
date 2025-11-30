set(KMPKG_BUILD_TYPE release) # header-only port

kmpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO mariusbancila/croncpp
  REF e817348a2dcd77b968c0b87a43274932b9800f4b # 2023-03-30
  SHA512 aee687f4e8d7ce85aa9ba3a9e551443353abc20af9face62b618ce55ffa7a4632a4cd0c02c46e43c52b7f1797d62006183776a2d7fad48473bb964af79c2d531
  HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
      -DCRONCPP_BUILD_TESTS=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

# Handle copyright
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
