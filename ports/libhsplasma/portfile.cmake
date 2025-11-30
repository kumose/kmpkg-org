string(REGEX REPLACE "-" "." REF_DOT_VERSION_DATE ${VERSION})

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO H-uru/libhsplasma
    REF "${REF_DOT_VERSION_DATE}"
    SHA512 bf882347b8272a06335776454c339ccb36edcc4068978c2675700cf124f319eccc23a739427a3e2f57e1f27c3f4c5281db9ce5a914de78e97704f8b94af61d8e
    HEAD_REF master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        net ENABLE_NET
)

kmpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        ${FEATURE_OPTIONS}
        -DENABLE_PHYSX=OFF
        -DENABLE_PYTHON=OFF
        -DENABLE_TOOLS=OFF

        # Catch2 test discovery has some odd interactions with PATH, which
        # appear to still be unresolved.  For simplicity, just skip tests.
        -DENABLE_TESTS=OFF
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(PACKAGE_NAME HSPlasma CONFIG_PATH share/cmake/HSPlasma)

kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
