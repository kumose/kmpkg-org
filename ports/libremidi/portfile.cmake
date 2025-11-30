kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO jcelerier/libremidi
    REF "v${VERSION}"
    SHA512 4ba9d06a171dc29c393d5401661cbefbd5cdcc00ae8a02cb64345367b829ea49b109056167ea86c0f85e1d4f6ce9a01be89c988f03dc90f02ae4943d13b74845
    HEAD_REF master
)

kmpkg_list(SET options)
if(KMPKG_TARGET_IS_LINUX)
    kmpkg_list(APPEND options -DLIBREMIDI_NO_ALSA=OFF)
else()
    kmpkg_list(APPEND options -DLIBREMIDI_NO_ALSA=ON)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${options}
        -DLIBREMIDI_NO_BOOST=ON
        -DLIBREMIDI_NO_JACK=ON
        -DLIBREMIDI_NO_PIPEWIRE=ON
)
kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.md")
