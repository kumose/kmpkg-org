kmpkg_download_distfile(ARCHIVE
    URLS "https://github.com/cppp-project/cppp-reiconv/releases/download/v${VERSION}/cppp-reiconv-v${VERSION}.zip"
    FILENAME "cppp-reiconv-v${VERSION}.zip"
    SHA512 56294d63a71818842ec3f4a513bdc022ea3f472b582e16d377ec61282005965e7a08d619b9620cc036feb391e5b2eab3bfb4a1a21dcc860df89234e847048678
)

kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE "${ARCHIVE}"
)

kmpkg_find_acquire_program(PYTHON3)
get_filename_component(PYTHON3_DIR ${PYTHON3} DIRECTORY)
kmpkg_add_to_path("${PYTHON3_DIR}")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
     OPTIONS -DENABLE_TEST=OFF -DENABLE_EXTRA=ON
)

kmpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
