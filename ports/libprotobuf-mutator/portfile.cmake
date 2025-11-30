if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_STATIC_LIBRARY)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO google/libprotobuf-mutator
    REF "v${VERSION}"
    SHA512 2fb374ff32c52aaf15ebff26e8fe11fc3ca1ef411da74bb6212ed5acaf20ae48e388b2b26d5c6786b85058ea7cd65e5ad5c55ea18916c1a701add34c6e62ebfe
    HEAD_REF master
)

string(COMPARE EQUAL "${KMPKG_CRT_LINKAGE}" "static" STATIC_RUNTIME)
kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCMAKE_CXX_STANDARD=17
        -DLIB_PROTO_MUTATOR_TESTING=OFF
        -DLIB_PROTO_MUTATOR_MSVC_STATIC_RUNTIME=${STATIC_RUNTIME}
        -DPKG_CONFIG_PATH=lib/pkgconfig
    MAYBE_UNUSED_VARIABLES
        LIB_PROTO_MUTATOR_MSVC_STATIC_RUNTIME
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
