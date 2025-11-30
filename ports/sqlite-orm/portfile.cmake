# header-only library

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO fnc12/sqlite_orm
    REF "v${VERSION}"
    SHA512 3e939ddb31e8f03a5f885e459b1ba8040b58e697a715148b829b075d612d1c8a5686ec889155ec9804929e11ec11285a39af3f1eb27a4edf0bcc56c4ee7530b1
    HEAD_REF master
    PATCHES 
        fix-dependency.patch
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        test BUILD_TESTING
        example BUILD_EXAMPLES
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DSQLITE_ORM_ENABLE_CXX_17=OFF
        -DSQLITE_ORM_ENABLE_CXX_20=OFF
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup(PACKAGE_NAME SqliteOrm CONFIG_PATH lib/cmake/SqliteOrm)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)