include(kmpkg_find_fortran)
kmpkg_find_fortran(FORTRAN_CMAKE)
set(KMPKG_POLICY_ALLOW_OBSOLETE_MSVCRT enabled)

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO opencollab/arpack-ng
    REF ${VERSION}
    SHA512 1ca590a8c4f75aa74402f9bd62e63851039687f4cb11afa8acb05fce1f22a512bff5fd1709ea85fdbea90b344fbbc01e3944c770b5ddc4d1aabc98ac334f78d2
    HEAD_REF master
)

if(NOT KMPKG_TARGET_IS_WINDOWS)
    set(ENV{FFLAGS} "$ENV{FFLAGS} -fPIC")
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FORTRAN_CMAKE}
        -DMPI=OFF
        -DICB=ON
        -DICBEXMM=OFF
        -DEXAMPLES=OFF
        -DTESTS=OFF
        -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON
)

kmpkg_cmake_install()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

kmpkg_cmake_config_fixup(PACKAGE_NAME arpackng CONFIG_PATH lib/cmake/arpackng)
kmpkg_fixup_pkgconfig()

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
