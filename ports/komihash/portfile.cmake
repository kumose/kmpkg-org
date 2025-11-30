# Header-only library
set(KMPKG_BUILD_TYPE "release")

kmpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO avaneev/komihash
  REF "${VERSION}"
  SHA512 77d29bf1d428a5e42b348fd2bdc06977049b97ff5cda2f0d72dccf748d03ad73b3106fe9bd86dc1ad4f83e0e65600e684431082cf325796c64005f9531304772
  HEAD_REF main
)

file(INSTALL "${SOURCE_PATH}/komihash.h" DESTINATION "${CURRENT_PACKAGES_DIR}/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
