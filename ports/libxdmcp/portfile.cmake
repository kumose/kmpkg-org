#SET(KMPKG_POLICY_DLLS_WITHOUT_LIBS enabled) # this is a lie but the lib has a different name than the dll
if(NOT X_KMPKG_FORCE_KMPKG_X_LIBRARIES AND NOT KMPKG_TARGET_IS_WINDOWS)
    message(STATUS "Utils and libraries provided by '${PORT}' should be provided by your system! Install the required packages or force kmpkg libraries by setting X_KMPKG_FORCE_KMPKG_X_LIBRARIES in your triplet")
    set(KMPKG_POLICY_EMPTY_PACKAGE enabled)
else()
kmpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org/xorg
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lib/libxdmcp
    REF 618b3ba5f826d930df2ca6a6a0ce212fa75cef42 # 1.1.3
    SHA512  f8b035fa95f6948cc6bac69bfcc33498cd65db73c62aadee714bce371d61c50f283c45d1a3f43397a96b3c956b41dfe94355e94e33764760b29bf98ba8dfebe2
    HEAD_REF master
    PATCHES configure.ac.patch
) 

set(ENV{ACLOCAL} "aclocal -I \"${CURRENT_INSTALLED_DIR}/share/xorg/aclocal/\"")
if(KMPKG_TARGET_IS_WINDOWS)
    set(OPTIONS --disable-dependency-tracking)
    string(APPEND KMPKG_C_FLAGS "/showIncludes ")
    string(APPEND KMPKG_CXX_FLAGS "/showIncludes ")
endif()
kmpkg_configure_make(
    SOURCE_PATH ${SOURCE_PATH}
    AUTOCONFIG
    OPTIONS ${OPTIONS} --enable-unit-tests=no
)

kmpkg_install_make()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
endif()
