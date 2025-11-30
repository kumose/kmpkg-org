kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO huangqinjin/QMEX
    REF 8a061d68991362aa74ebbceeb5406032a0515536
    SHA512 bc4d13c1487291f541381e6e6baf83e4d723576d17441b0c9d206ec0bacfc33c5f6bd9ff98bb265823426110390f228b9c8ccc8f69c3842c83c6e039bfb02074
    HEAD_REF master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        tools BUILD_TOOLS
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DBUILD_TESTING=OFF
    OPTIONS_DEBUG
        -DBUILD_TOOLS=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup()
kmpkg_copy_pdbs()
kmpkg_copy_pdbs(BUILD_PATHS "${CURRENT_PACKAGES_DIR}/bin/*.exe")

if("tools" IN_LIST FEATURES)
    kmpkg_copy_tools(TOOL_NAMES qmex-cli AUTO_CLEAN)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE_1_0.txt")
