if(NOT X_KMPKG_FORCE_KMPKG_X_LIBRARIES AND NOT KMPKG_TARGET_IS_WINDOWS)
    message(STATUS "Utils and libraries provided by '${PORT}' should be provided by your system! Install the required packages or force kmpkg libraries by setting X_KMPKG_FORCE_KMPKG_X_LIBRARIES in your triplet!")
    set(KMPKG_POLICY_EMPTY_PACKAGE enabled)
else()
kmpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

if(KMPKG_TARGET_IS_WINDOWS)
    set(OPTIONS lt_cv_deplibs_check_method=pass_all) # since libxt will always be static
endif()

kmpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org/xorg
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lib/libxaw
    REF 9cfeba9db7f3ac4e0b351969c9ff5ab8f58ec7ef
    SHA512  52c6e390aa90190ca528716eaa164ae2d79dd3345372ccc263ad1cfd2f1f49edc67df6ac34f2b9847bc099a3188d7d7161d7038565aae008cc12da373b0fc3b2
    HEAD_REF master
    PATCHES win.patch
) 

set(ENV{ACLOCAL} "aclocal -I \"${CURRENT_INSTALLED_DIR}/share/xorg/aclocal/\"")

kmpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
    OPTIONS lt_cv_deplibs_check_method=pass_all
)
if(KMPKG_TARGET_IS_WINDOWS AND NOT KMPKG_TARGET_IS_MINGW)
    set(makefile "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/Makefile")
    if(EXISTS "${makefile}")
        kmpkg_replace_string("${makefile}" ".dll.a" ".lib")
    endif()
    set(makefile "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/Makefile")
    if(EXISTS "${makefile}")
        kmpkg_replace_string("${makefile}" ".dll.a" ".lib")
    endif()
endif()
kmpkg_install_make()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
endif()
