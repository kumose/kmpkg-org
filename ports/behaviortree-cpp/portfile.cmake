kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO BehaviorTree/BehaviorTree.CPP
    REF ${VERSION}
    SHA512 65bb1c11ca48b199c2c3a6818fb8896dcddf52f02683214aba73bd4db3d8c749b200f0cc75f932ac25f8c5dbf19a6ccbf5d1ad556a7d70e430c4336b3de8039b
    HEAD_REF master
    PATCHES
        fix-x86_build.patch
        remove-source-charset.diff
        fix-dependencies.patch
)

# Set BTCPP_SHARED_LIBS based on KMPKG_LIBRARY_LINKAGE
if(KMPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    set(BTCPP_SHARED_LIBS ON)
else()
    set(BTCPP_SHARED_LIBS OFF)
endif()

# Remove vendored lexy directory to prevent conflicts with foonathan-lexy port
file(REMOVE_RECURSE "${SOURCE_PATH}/3rdparty/lexy")

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCMAKE_DISABLE_FIND_PACKAGE_ament_cmake=1
        -DCMAKE_DISABLE_FIND_PACKAGE_Curses=1
        -DBTCPP_EXAMPLES=OFF
        -DBUILD_TESTING=OFF
        -DBTCPP_BUILD_TOOLS=OFF
        -DBTCPP_GROOT_INTERFACE=OFF
        -DBTCPP_SQLITE_LOGGING=OFF
        -DBTCPP_SHARED_LIBS=${BTCPP_SHARED_LIBS}
        -DUSE_VENDORED_FLATBUFFERS=OFF
        -DUSE_VENDORED_LEXY=OFF
        -DUSE_VENDORED_MINITRACE=OFF
        -DUSE_VENDORED_TINYXML2=OFF
    MAYBE_UNUSED_VARIABLES
        CMAKE_DISABLE_FIND_PACKAGE_Curses
)

kmpkg_cmake_install()
kmpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/behaviortree_cpp PACKAGE_NAME behaviortree_cpp)
kmpkg_copy_pdbs()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
