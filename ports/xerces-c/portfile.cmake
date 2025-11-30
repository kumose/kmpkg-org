kmpkg_minimum_required(VERSION 2022-10-12) # for ${VERSION}
kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO apache/xerces-c
    REF "v${VERSION}"
    SHA512 228f7b35ca219a2d5202b853983fd2941325413724f9cfbb8d0056bb81669c4530a792323f60736e4f6bf2c4f289fab21d6e2107e9ba65438437ae19b374b4a8
    HEAD_REF master
    PATCHES
        dependencies.patch
        disable-tests.patch
        remove-dll-export-macro.patch
)
file(REMOVE "${SOURCE_PATH}/cmake/FindICU.cmake")

kmpkg_check_features(
    OUT_FEATURE_OPTIONS options
    FEATURES
        icu     CMAKE_REQUIRE_FIND_PACKAGE_ICU
        network network
    INVERTED_FEATURES
        icu     CMAKE_DISABLE_FIND_PACKAGE_ICU
)
if("icu" IN_LIST FEATURES)
    kmpkg_list(APPEND options -Dtranscoder=icu)
elseif(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_list(APPEND options -Dtranscoder=windows)
elseif(KMPKG_TARGET_IS_OSX)
    kmpkg_list(APPEND options -Dtranscoder=macosunicodeconverter)
elseif(KMPKG_HOST_IS_OSX)
    # Because of a bug in the transcoder selection script, the option
    # "macosunicodeconverter" is always selected when building on macOS,
    # regardless of the target platform. This breaks cross-compiling.
    # As a workaround we force "iconv", which should at least work for iOS.
    # Upstream fix: https://github.com/apache/xerces-c/pull/52
    kmpkg_list(APPEND options -Dtranscoder=iconv)
else()
    # xercesc chooses gnuiconv or iconv (cmake/XercesTranscoderSelection.cmake)
endif()
if("xmlch-wchar" IN_LIST FEATURES)
    kmpkg_list(APPEND options -Dxmlch-type=wchar_t)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DDISABLE_TESTS=ON
        -DDISABLE_DOC=ON
        -DDISABLE_SAMPLES=ON
        -DCMAKE_DISABLE_FIND_PACKAGE_CURL=ON
        ${options}
    MAYBE_UNUSED_VARIABLES
        CMAKE_DISABLE_FIND_PACKAGE_CURL
)

kmpkg_cmake_install()

kmpkg_copy_pdbs()

if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_cmake_config_fixup(CONFIG_PATH cmake PACKAGE_NAME xercesc)
else()
    kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/XercesC PACKAGE_NAME xercesc)
endif()

configure_file("${CMAKE_CURRENT_LIST_DIR}/kmpkg-cmake-wrapper.cmake" "${CURRENT_PACKAGES_DIR}/share/xercesc/kmpkg-cmake-wrapper.cmake" @ONLY)

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

kmpkg_fixup_pkgconfig()
if (KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/lib/pkgconfig/xerces-c.pc" "-lxerces-c" "-lxerces-c_3")
    if(NOT KMPKG_BUILD_TYPE)
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/debug/lib/pkgconfig/xerces-c.pc" "-lxerces-c" "-lxerces-c_3D")
    endif()
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
