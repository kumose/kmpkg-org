
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO midi2-dev/AM_MIDI2.0Lib
    REF "v${VERSION}"
    SHA512 d7a30cad1071dcd5b07f9c1aec06f2f53424b076517d47760629766652e75ac46ab75324d4bd14a7601b92e5f0a213264e36c59517f2ba12dcf4d28ba7ebf8b2
    HEAD_REF main
)

if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}")
kmpkg_cmake_install()
kmpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

