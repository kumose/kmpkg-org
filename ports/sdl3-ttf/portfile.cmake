kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO  libsdl-org/SDL_ttf
    REF "release-${VERSION}"
    SHA512 b9adc28d584759b1cc1072d071caad95ade263a1fb24e294d66fc15e132d44bc62925875cb1f1b596089def9b47d7b73f42ffa4e120ee51982f993dc7a7d3bd7 
    HEAD_REF main
    PATCHES
        link-sdl3.diff
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        harfbuzz SDLTTF_HARFBUZZ
        svg      SDLTTF_PLUTOSVG
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DSDLTTF_SAMPLES=OFF
        -DSDLTTF_STRICT=ON
        -DSDLTTF_VENDORED=OFF
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()
if(EXISTS "${CURRENT_PACKAGES_DIR}/cmake")
    kmpkg_cmake_config_fixup(PACKAGE_NAME sdl3_ttf CONFIG_PATH cmake)
else()
    kmpkg_cmake_config_fixup(PACKAGE_NAME sdl3_ttf CONFIG_PATH lib/cmake/SDL3_ttf)
endif()

kmpkg_fixup_pkgconfig()
if(KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW AND KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/sdl3-ttf.pc" " -lSDL3_ttf" " -lSDL3_ttf-static")
    if(NOT KMPKG_BUILD_TYPE)
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/sdl3-ttf.pc" " -lSDL3_ttf" " -lSDL3_ttf-static")
    endif()
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/licenses")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
