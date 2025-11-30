set(KMPKG_BUILD_TYPE release) # header-only library

kmpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO Alan-Jowett/dagir
  REF 0.1.0
  SHA512 0450b03c282daa9b941a56283ccc00663c8eb66c9d02bdae05d2ea5dd60c4048a30ba4b4d3f51fe51d7a7f43132d48989140fc02d088522a2177ff779c204ed3
)


kmpkg_cmake_configure(
  SOURCE_PATH ${SOURCE_PATH} 
  OPTIONS 
    -DDAGIR_BUILD_TESTS=OFF 
    -DDAGIR_EXAMPLES=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/DagIR")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
