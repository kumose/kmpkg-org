# Upstream uses CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS, which causes issues
# https://github.com/thestk/rtmidi/blob/4.0.0/CMakeLists.txt#L20
kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO thestk/rtmidi
    REF "${VERSION}"
    SHA512 7ff7f85ff86fc019ab7906a46efc986b2a340b2f9a9d504bda85d0afc75921b905b32cb37f87e30ab9d1f13e62587c4ade736dad1609a0880eeab3fe5a936acb
    HEAD_REF master
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        alsa RTMIDI_API_ALSA
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DRTMIDI_API_JACK=OFF
        -DRTMIDI_BUILD_TESTING=OFF
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_fixup_pkgconfig()

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
