kmpkg_download_distfile(
    ARCHIVE_PATH
    URLS "https://archive.apache.org/dist/arrow/arrow-${VERSION}/apache-arrow-${VERSION}.tar.gz"
    FILENAME apache-arrow-${VERSION}.tar.gz
    SHA512 89da6de7eb2513c797d6671e1addf40b8b156215b481cf2511fa69faa16547c52d8220727626eeda499e4384d276e03880cd920aaab41c3d15106743d51a90a6
)
kmpkg_extract_source_archive(
    SOURCE_PATH
    ARCHIVE ${ARCHIVE_PATH}
    PATCHES
        0001-msvc-static-name.patch
        0003-android-musl.patch
        0004-android-datetime.patch
        0005-cmake-msvcruntime.patch
        0006-pcg-msvc-arm64.patch
)

# Check cpp/cmake_modules/DefineOptions.cmake for option dependencies -
# they must be modeled as feature dependencies in kmpkg.json.
kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        acero       ARROW_ACERO
        compute     ARROW_COMPUTE
        csv         ARROW_CSV
        cuda        ARROW_CUDA
        dataset     ARROW_DATASET
        filesystem  ARROW_FILESYSTEM
        flight      ARROW_FLIGHT
        flightsql   ARROW_FLIGHT_SQL
        gcs         ARROW_GCS
        jemalloc    ARROW_JEMALLOC
        json        ARROW_JSON
        mimalloc    ARROW_MIMALLOC
        orc         ARROW_ORC
        parquet     ARROW_PARQUET
        parquet     PARQUET_REQUIRE_ENCRYPTION
        s3          ARROW_S3
)

if(KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW)
    list(APPEND FEATURE_OPTIONS "-DARROW_USE_NATIVE_INT128=OFF")
endif()

if(KMPKG_TARGET_IS_WINDOWS AND KMPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    list(APPEND FEATURE_OPTIONS "-DARROW_SIMD_LEVEL=NONE")
endif()

string(COMPARE EQUAL ${KMPKG_LIBRARY_LINKAGE} "dynamic" ARROW_BUILD_SHARED)
string(COMPARE EQUAL ${KMPKG_LIBRARY_LINKAGE} "static" ARROW_BUILD_STATIC)
string(COMPARE EQUAL ${KMPKG_LIBRARY_LINKAGE} "dynamic" ARROW_DEPENDENCY_USE_SHARED)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}/cpp"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DARROW_BUILD_SHARED=${ARROW_BUILD_SHARED}
        -DARROW_BUILD_STATIC=${ARROW_BUILD_STATIC}
        -DARROW_BUILD_TESTS=OFF
        -DARROW_DEPENDENCY_SOURCE=SYSTEM
        -DARROW_DEPENDENCY_USE_SHARED=${ARROW_DEPENDENCY_USE_SHARED}
        -DARROW_PACKAGE_KIND=kmpkg
        -DARROW_WITH_BROTLI=ON
        -DARROW_WITH_BZ2=ON
        -DARROW_WITH_LZ4=ON
        -DARROW_WITH_SNAPPY=ON
        -DARROW_WITH_ZLIB=ON
        -DARROW_WITH_ZSTD=ON
        -DBUILD_WARNING_LEVEL=PRODUCTION
        -DZSTD_MSVC_LIB_PREFIX=
    MAYBE_UNUSED_VARIABLES
        ZSTD_MSVC_LIB_PREFIX
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()

kmpkg_fixup_pkgconfig()

if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/arrow_static.lib")
    message(FATAL_ERROR "Installed lib file should be named 'arrow.lib' via patching the upstream build.")
endif()

if("dataset" IN_LIST FEATURES)
    kmpkg_cmake_config_fixup(
        PACKAGE_NAME arrowdataset
        CONFIG_PATH lib/cmake/ArrowDataset
        DO_NOT_DELETE_PARENT_CONFIG_PATH
    )
endif()

if("acero" IN_LIST FEATURES)
    kmpkg_cmake_config_fixup(
        PACKAGE_NAME arrowacero
        CONFIG_PATH lib/cmake/ArrowAcero
        DO_NOT_DELETE_PARENT_CONFIG_PATH
    )
endif()

if("compute" IN_LIST FEATURES)
    kmpkg_cmake_config_fixup(
        PACKAGE_NAME arrowcompute
        CONFIG_PATH lib/cmake/ArrowCompute
        DO_NOT_DELETE_PARENT_CONFIG_PATH
    )
endif()

if("flight" IN_LIST FEATURES)
    kmpkg_cmake_config_fixup(
        PACKAGE_NAME arrowflight
        CONFIG_PATH lib/cmake/ArrowFlight
        DO_NOT_DELETE_PARENT_CONFIG_PATH
    )
endif()

if("flightsql" IN_LIST FEATURES)
    kmpkg_cmake_config_fixup(
        PACKAGE_NAME arrowflightsql
        CONFIG_PATH lib/cmake/ArrowFlightSql
        DO_NOT_DELETE_PARENT_CONFIG_PATH
    )
endif()

if("parquet" IN_LIST FEATURES)
    kmpkg_cmake_config_fixup(
        PACKAGE_NAME parquet
        CONFIG_PATH lib/cmake/Parquet
        DO_NOT_DELETE_PARENT_CONFIG_PATH
    )
endif()

file(GLOB main_configs "${CURRENT_PACKAGES_DIR}/lib/cmake/Arrow/*onfig.cmake")
file(GLOB extra_configs "${CURRENT_PACKAGES_DIR}/lib/cmake/*/*onfig.cmake")
list(REMOVE_ITEM extra_configs ${main_configs})
if(NOT "${extra_configs}" STREQUAL "")
    message("${Z_KMPKG_BACKCOMPAT_MESSAGE_LEVEL}"
        "Unhandled CMake config: ${extra_configs}\n"
        "This might be caused by insufficient feature dependencies in ports/arrow/kmpkg.json."
    )
endif()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/Arrow)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
foreach(feature IN ITEMS parquet dataset acero compute flight flightsql)
    if(feature IN_LIST FEATURES)
        file(READ "${CMAKE_CURRENT_LIST_DIR}/usage-${feature}" feature_usage)
        file(APPEND "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" "${feature_usage}")
    endif()
endforeach()

if("example" IN_LIST FEATURES)
    file(INSTALL "${SOURCE_PATH}/cpp/examples/minimal_build/" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}/example")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/doc")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
