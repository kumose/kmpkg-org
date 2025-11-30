kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KarypisLab/ParMETIS
    REF 8ee6a372ca703836f593e3c450ca903f04be14df
    SHA512 a71d212a1c8682eb662ef6bb8bdcb124bc13c353e76ac236b01e544bddb975740c36be54c05305e1114e4daf20fec56642ffa319a6426c87c5538ea2225c156b
    PATCHES
        build-fixes.patch
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSHARED=OFF
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
