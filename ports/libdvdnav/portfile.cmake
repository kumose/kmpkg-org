kmpkg_from_gitlab(
    OUT_SOURCE_PATH SOURCE_PATH
    GITLAB_URL https://code.videolan.org/
    REPO videolan/libdvdnav
    REF ${VERSION}
    SHA512 080814c30f193176393bf6d4496a1e815b3b288cd102201ba177a13a46f733e1e0b5e05d6ca169e902c669d6f3567926c97e5a20a6712ed5620dcb10c3c3a022
    HEAD_REF master
    PATCHES
        msvc.diff
        no-undefined.diff
)
file(REMOVE_RECURSE "${SOURCE_PATH}/msvc/include/inttypes.h")

kmpkg_find_acquire_program(PKGCONFIG)
cmake_path(GET PKGCONFIG PARENT_PATH pkgconfig_dir)
kmpkg_add_to_path("${pkgconfig_dir}")

set(cppflags "")
if(KMPKG_TARGET_IS_WINDOWS)
    # PATH_MAX from msvc/libdvdcss.vcxproj
    set(cppflags "CPPFLAGS=\$CPPFLAGS -DPATH_MAX=2048 -DWIN32_LEAN_AND_MEAN")
    if(NOT KMPKG_TARGET_IS_MINGW)
        cmake_path(RELATIVE_PATH SOURCE_PATH BASE_DIRECTORY "${CURRENT_BUILDTREES_DIR}" OUTPUT_VARIABLE sources)
        string(APPEND cppflags " -I../${sources}/msvc/include -D_CRT_SECURE_NO_WARNINGS")
    endif()
endif()

kmpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
    OPTIONS
        ${cppflags}
)
kmpkg_install_make()
kmpkg_copy_pdbs()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
