kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO silverqx/TinyORM
    REF "v${VERSION}"
    SHA512 231601df0e0b9233e6e206717c8ccbe2431ed545858d7efbbad96c7821177d6103d231941fa1bccae8fd2593b5874969bb4e26089d7502839106488d2cd614b6
    HEAD_REF main
)

# STL4043 _SILENCE_STDEXT_ARR_ITERS_DEPRECATION_WARNING already defined, see:
# https://github.com/silverqx/TinyORM/blob/main/cmake/CommonModules/TinyCommon.cmake#L122

kmpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    PREFIX TINYORM
    FEATURES
        disable-thread-local DISABLE_THREAD_LOCAL
        inline-constants     INLINE_CONSTANTS
        mysql-ping           MYSQL_PING
        orm                  ORM
        strict-mode          STRICT_MODE
        tom                  TOM
        tom-example          TOM_EXAMPLE
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCMAKE_CXX_SCAN_FOR_MODULES:BOOL=OFF
        -DCMAKE_EXPORT_PACKAGE_REGISTRY:BOOL=OFF
        -DBUILD_TESTS:BOOL=OFF
        -DBUILD_TREE_DEPLOY:BOOL=OFF
        -DTINY_PORT:STRING=${PORT}
        -DTINY_KMPKG:BOOL=ON
        -DVERBOSE_CONFIGURE:BOOL=ON
        ${FEATURE_OPTIONS}
)

kmpkg_cmake_install()

kmpkg_cmake_config_fixup()

if(TINYORM_TOM_EXAMPLE)
    kmpkg_copy_tools(TOOL_NAMES tom AUTO_CLEAN)
endif()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
