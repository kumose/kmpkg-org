kmpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO twig-energy/bark
  REF "${VERSION}"
  HEAD_REF main
  SHA512 b247305144da5a6a95896915e022c4fc589e49bfae32951008e7c36e11769e35da68c8c9c5eed69fa7265b9af7658e251663f08f346f993613ae59961578efc3
)

if(KMPKG_TARGET_IS_WINDOWS)  
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)  
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCMAKE_CXX_STANDARD=20
        -DCMAKE_CXX_STANDARD_REQUIRED=ON
        -DCMAKE_CXX_EXTENSIONS=OFF)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/bark)
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CURRENT_PORT_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}") 

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
