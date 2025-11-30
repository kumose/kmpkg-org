kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO unicorn-engine/unicorn
    REF "${VERSION}"
    SHA512 c9ae4230a20b77e0187cde33dbf4827b3504b6c24debd61fc79ec9c13fa2051335c834c101433cebbbc8e3baadae56212b79c5922bf37ea1f777d66d8e67b495
    HEAD_REF master
    PATCHES
        fix-build.patch
        fix-msvc-shared.patch
)

if(KMPKG_TARGET_IS_ANDROID)
    kmpkg_replace_string("${SOURCE_PATH}/CMakeLists.txt"
        "-lpthread"
        " "
    )
endif()

if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_replace_string("${SOURCE_PATH}/CMakeLists.txt"
        "-lpthread -lm"
        " "
    )
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DUNICORN_BUILD_TESTS=OFF
)

kmpkg_cmake_install()
kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
