kmpkg_from_gitlab(
    GITLAB_URL https://gitlab.com/inivation/
    OUT_SOURCE_PATH SOURCE_PATH
    REPO dv/libcaer
    REF "${VERSION}"
    SHA512 651e7e92730be6e10e1efab9c11a111e99b338a29239a79d61169c8130c4149eda99a624205db36c4a21da023ff1525f31c4175947f72c78bc2a8b40c9d2c2ab
    HEAD_REF master
)

find_program(PKGCONFIG NAMES pkgconf PATHS "${CURRENT_HOST_INSTALLED_DIR}/tools/pkgconf" NO_DEFAULT_PATH REQUIRED)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        opencv     ENABLE_OPENCV
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE # writes to include/libcaer/libcaer.h
    OPTIONS
        ${FEATURE_OPTIONS}
        -DEXAMPLES_INSTALL=OFF
        -DBUILD_CONFIG_KMPKG=ON
        "-DPKG_CONFIG_EXECUTABLE=${PKGCONFIG}"
)

kmpkg_cmake_install()

kmpkg_fixup_pkgconfig()
kmpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

set(stdatomic_license "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/LICENSE for simple-stdatomic (x86,x64 MSVC)")
file(COPY_FILE "${SOURCE_PATH}/thirdparty/simple-stdatomic/LICENSE" "${stdatomic_license}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE" "${stdatomic_license}")
