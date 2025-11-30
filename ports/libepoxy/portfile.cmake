if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)
endif()

if (KMPKG_TARGET_IS_LINUX)
    message(WARNING "${PORT} currently requires the following libraries from the system package manager:\n    libx11-dev\n    libgles2-mesa-dev\n\nThese can be installed on Ubuntu systems via apt-get install libx11-dev libgles2-mesa-dev.")
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO anholt/libepoxy
    REF 1.5.10
    SHA512 6786f31c6e2865e68a90eb912900a86bf56fd3df4d78a477356886ac3b6ef52ac887b9c7a77aa027525f868ae9e88b12e5927ba56069c2e115acd631fca3abee
    HEAD_REF master
)

if (KMPKG_TARGET_IS_WINDOWS OR KMPKG_TARGET_IS_OSX)
    set(OPTIONS -Dglx=no -Degl=no -Dx11=false)
elseif(KMPKG_TARGET_IS_ANDROID)
    set(OPTIONS -Dglx=no -Degl=yes -Dx11=false)
else()
    set(OPTIONS -Dglx=yes -Degl=yes -Dx11=true)
endif()
if(KMPKG_TARGET_IS_WINDOWS)
    list(APPEND OPTIONS -Dc_std=c99)
    if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
        list(APPEND OPTIONS "-Dc_args=-DEPOXY_PUBLIC=extern")
    endif()
endif()

kmpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${OPTIONS}
        -Dtests=false
)
kmpkg_install_meson()
kmpkg_copy_pdbs()

kmpkg_fixup_pkgconfig()

if(KMPKG_TARGET_IS_WINDOWS)
    kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/epoxy/common.h" "# if defined(_MSC_VER)" "# if defined(_WIN32)")
    if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
        kmpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/epoxy/common.h" "__declspec(dllimport)" "")
    endif()
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/share/pkgconfig")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share/pkgconfig")

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
