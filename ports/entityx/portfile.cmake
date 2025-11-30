kmpkg_check_linkage(ONLY_STATIC_LIBRARY)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO alecthomas/entityx
    REF 1.3.0
    SHA512 724a3f421f802e60a1106ff8a69435c9a9da14e35c3e88565bbc17bff3a17f2d9771818aac83320cc4f14de0ec770a66f1eb7cbf4318f43abd516c63e077c07d
    HEAD_REF master
)

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    DISABLE_PARALLEL_CONFIGURE
    OPTIONS
        -DCMAKE_CXX_STANDARD=11 # std::iterator<X,Y> is deprecated in C++17
        -DENTITYX_BUILD_TESTING=false
        -DENTITYX_BUILD_SHARED=0
)

kmpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/entityx" RENAME copyright)
