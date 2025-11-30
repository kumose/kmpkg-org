set(KMPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)

kmpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        "force-build" FORCE_BUILD
)

if(NOT X_KMPKG_FORCE_KMPKG_WAYLAND_LIBRARIES AND NOT KMPKG_TARGET_IS_WINDOWS AND NOT FORCE_BUILD)
    message(STATUS "Utils and libraries provided by '${PORT}' should be provided by your system! Install the required packages or force kmpkg libraries by setting X_KMPKG_FORCE_KMPKG_WAYLAND_LIBRARIES")
    set(KMPKG_POLICY_EMPTY_PACKAGE enabled)
    return()
endif()


if(NOT FORCE_BUILD OR NOT X_KMPKG_FORCE_KMPKG_WAYLAND_LIBRARIES)
    message(FATAL_ERROR "To build wayland libraries the `force-build` feature must be enabled and the X_KMPKG_FORCE_KMPKG_WAYLAND_LIBRARIES triplet variable must be set.")
endif()

kmpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org
    OUT_SOURCE_PATH SOURCE_PATH
    REPO wayland/wayland-protocols
    REF ${VERSION}
    SHA512 bcc938a5bac59020ded9c653a4d65cafc42eed7d72518125b6d3d710b468ab3db71d514437cbe80d24821fb65eb2b078cd906c18f35245b0c99ad892b0ba50d0
    HEAD_REF master
    PATCHES
        cross-build.diff
)

kmpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -Dtests=false
    ADDITIONAL_BINARIES
        "wayland_scanner = ['${CURRENT_HOST_INSTALLED_DIR}/tools/wayland/wayland-scanner${KMPKG_HOST_EXECUTABLE_SUFFIX}']"
)
kmpkg_install_meson()
kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYING")
