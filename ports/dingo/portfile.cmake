set(KMPKG_BUILD_TYPE release) # header-only
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO romanpauk/dingo
    REF "v${VERSION}"
    HEAD_REF master
    SHA512 a302e8e504a9f0a863c729432a479134ade96198af48219064d8f3f1e18ef78541e93048811865cd8cb878e5a0837ed98425e7481fd08726806e6b72aa57f908 
)

kmpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
kmpkg_cmake_install()
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

