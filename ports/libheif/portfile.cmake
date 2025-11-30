kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO  strukturag/libheif
    REF "v${VERSION}"
    SHA512 4497d1afbccc15806cc11c22653e83d7900a009ad584a8d6b1ada6fac1ace9a70d834eb32653da567f0ddabc23ec641c5d69503282e303bf1bf2def72544b1b5
    HEAD_REF master
    PATCHES
        cxx-linkage-pkgconfig.diff
        find-modules.diff
        gdk-pixbuf.patch
        symbol-exports.diff
)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        aom         WITH_AOM_DECODER
        aom         WITH_AOM_ENCODER
        aom         KMPKG_LOCK_FIND_PACKAGE_AOM
        gdk-pixbuf  WITH_GDK_PIXBUF
        hevc        WITH_X265
        hevc        KMPKG_LOCK_FIND_PACKAGE_X265
        iso23001-17 WITH_UNCOMPRESSED_CODEC
        iso23001-17 KMPKG_LOCK_FIND_PACKAGE_ZLIB
        jpeg        WITH_JPEG_DECODER
        jpeg        WITH_JPEG_ENCODER
        jpeg        KMPKG_LOCK_FIND_PACKAGE_JPEG
        openjpeg    WITH_OpenJPEG_DECODER
        openjpeg    WITH_OpenJPEG_ENCODER
        openjpeg    KMPKG_LOCK_FIND_PACKAGE_OpenJPEG
)

kmpkg_find_acquire_program(PKGCONFIG)
set(ENV{PKG_CONFIG} "${PKGCONFIG}")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_TESTING=OFF
        -DCMAKE_COMPILE_WARNING_AS_ERROR=OFF
        "-DCMAKE_PROJECT_INCLUDE=${CURRENT_PORT_DIR}/cmake-project-include.cmake"
        -DPLUGIN_DIRECTORY=  # empty
        -DWITH_DAV1D=OFF
        -DWITH_EXAMPLES=OFF
        -DWITH_LIBSHARPYUV=OFF
        -DWITH_OpenH264_DECODER=OFF
        -DKMPKG_LOCK_FIND_PACKAGE_Brotli=OFF
        -DKMPKG_LOCK_FIND_PACKAGE_Doxygen=OFF
        -DKMPKG_LOCK_FIND_PACKAGE_LIBDE265=ON   # feature candidate
        -DKMPKG_LOCK_FIND_PACKAGE_PNG=OFF
        -DKMPKG_LOCK_FIND_PACKAGE_TIFF=OFF
        ${FEATURE_OPTIONS}
    OPTIONS_RELEASE
        "-DPLUGIN_INSTALL_DIRECTORY=${CURRENT_PACKAGES_DIR}/plugins/libheif"
    OPTIONS_DEBUG
        "-DPLUGIN_INSTALL_DIRECTORY=${CURRENT_PACKAGES_DIR}/debug/plugins/libheif"
    MAYBE_UNUSED_VARIABLES
        KMPKG_LOCK_FIND_PACKAGE_AOM
        KMPKG_LOCK_FIND_PACKAGE_Brotli
        KMPKG_LOCK_FIND_PACKAGE_OpenJPEG
        KMPKG_LOCK_FIND_PACKAGE_X265
        KMPKG_LOCK_FIND_PACKAGE_ZLIB
)
kmpkg_cmake_install()
kmpkg_copy_pdbs()
kmpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/libheif")
kmpkg_fixup_pkgconfig()

if (KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/libheif/heif_library.h" "!defined(LIBHEIF_STATIC_BUILD)" "1")
else()
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/libheif/heif_library.h" "!defined(LIBHEIF_STATIC_BUILD)" "0")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib/libheif" "${CURRENT_PACKAGES_DIR}/debug/lib/libheif")

file(GLOB maybe_plugins "${CURRENT_PACKAGES_DIR}/plugins/libheif/*")
if(maybe_plugins STREQUAL "")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/plugins" "${CURRENT_PACKAGES_DIR}/debug/plugins")
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
