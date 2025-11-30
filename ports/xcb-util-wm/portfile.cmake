if(NOT X_KMPKG_FORCE_KMPKG_X_LIBRARIES AND NOT KMPKG_TARGET_IS_WINDOWS)
    message(STATUS "Utils and libraries provided by '${PORT}' should be provided by your system! Install the required packages or force kmpkg libraries by setting X_KMPKG_FORCE_KMPKG_X_LIBRARIES in your triplet!")
    set(KMPKG_POLICY_EMPTY_PACKAGE enabled)
else()

kmpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org/xorg
    OUT_SOURCE_PATH SOURCE_PATH
    REPO lib/libxcb-wm
    REF  0c6681e465c9cc7b1fbb60778ba1eaa61ab01a14 #v 0.4.2
    SHA512 c8be48000ad2dbe5bd430241745edb16280c2d7e602872ed8e14e6245e64391cbf8f234a4d83aad65c96ec58c3b312f2fe7f0bf01cb82f46b3e50f2358b94741
    HEAD_REF master
    PATCHES build.patch
)
file(TOUCH "${SOURCE_PATH}/m4/dummy")
set(ENV{ACLOCAL} "aclocal -I \"${CURRENT_INSTALLED_DIR}/share/xorg/aclocal/\"")

kmpkg_configure_make(
    SOURCE_PATH "${SOURCE_PATH}"
    AUTOCONFIG
)

kmpkg_install_make()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
endif()
