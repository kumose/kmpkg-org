if(KMPKG_TARGET_IS_WINDOWS)
  message(WARNING
    "You will need to also install https://raw.githubusercontent.com/unicode-org/cldr/master/common/supplemental/windowsZones.xml into your install location.\n"
    "See https://howardhinnant.github.io/date/tz.html"
  )
endif()

kmpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO HowardHinnant/date
  REF "v${VERSION}"
  SHA512 9bffca5c7cfd1769f66bef330fe4ef0ad2512a8afd229ddb4043a4f166741e697c7a5fbdddf29f7157b3fc2c2c2a80fa7cff45078f1d8ab248d3b07e14518fcf
  HEAD_REF master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    INVERTED_FEATURES
    remote-api USE_SYSTEM_TZ_DB
)

kmpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS
    ${FEATURE_OPTIONS}
    -DBUILD_TZ_LIB=ON
)

kmpkg_cmake_install()

if(KMPKG_TARGET_IS_WINDOWS)
  kmpkg_cmake_config_fixup(CONFIG_PATH CMake)
else()
  kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/date")
endif()

kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
