kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO laurikari/tre
    REF 6fb7206b935b35814c5078c20046dbe065435363
    SHA512 f1d664719eab23b665d71e34ca3d11f8ba49da23ff20dc28f46d4ce30fe155c12208ba7fd212dbeb20a7037e069909f0c2120ce1fc01074656399805e3289a90
    HEAD_REF master
    PATCHES
        fix-config.patch
)

if(KMPKG_TARGET_IS_MINGW)
    kmpkg_replace_string("${SOURCE_PATH}/win32/tre.def" "tre.dll" "libtre.dll")
endif()

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(PACKAGE_NAME unofficial-${PORT})

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
