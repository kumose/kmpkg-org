kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ampl/asl
    REF ae937db9bd1169ec2c4cb8d75196f67cdcb8041b
    SHA512 7d0b2decb71397daa88ce328c23e782dab43b32fd6a51f031db8d4eed94abc6261892553faa990236a705a521de45c418261bbeba43f31bbee426c2c177af0cd
    HEAD_REF master
    PATCHES
        workaround-msvc-optimizer-ice.patch
        0006-disable-generate-arith-h.diff
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_MCMODELLARGE=OFF
        -DBUILD_DYNRT_LIBS=OFF # CRT linkage uses C/CXX FLAGS in kmpkg
        -DBUILD_MT_LIBS=OFF # CRT linkage uses C/CXX FLAGS in kmpkg
        -DBUILD_CPP=ON
)

kmpkg_cmake_install()

kmpkg_copy_pdbs()

kmpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
