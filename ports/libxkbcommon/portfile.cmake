if(NOT X_KMPKG_FORCE_KMPKG_X_LIBRARIES AND NOT KMPKG_TARGET_IS_WINDOWS)
    message(STATUS "Utils and libraries provided by '${PORT}' should be provided by your system! Install the required packages or force kmpkg libraries by setting X_KMPKG_FORCE_KMPKG_X_LIBRARIES in your triplet!")
    set(KMPKG_POLICY_EMPTY_PACKAGE enabled)
else()

set(PATCHES "")
if(KMPKG_TARGET_IS_WINDOWS)
    #kmpkg_check_linkage(ONLY_STATIC_LIBRARY) # Meson is not able to automatically export symbols for DLLs
    set(PATCHES build.patch)
endif()

kmpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO xkbcommon/libxkbcommon
    REF "xkbcommon-${VERSION}"
    SHA512  454fbb2861405ca957d64035e924c1bbb7d43db7867903963fc053b7ecb64a8fba89a21cc8ac18ebeec9b61ae0789fb88c52521a850dc371857f28b08e80167b
    HEAD_REF master
    PATCHES
        disable-test.patch
        ${PATCHES}
)

kmpkg_find_acquire_program(FLEX)
get_filename_component(FLEX_DIR "${FLEX}" DIRECTORY )
kmpkg_add_to_path(PREPEND "${FLEX_DIR}")

kmpkg_find_acquire_program(BISON)
get_filename_component(BISON_DIR "${BISON}" DIRECTORY )
kmpkg_add_to_path(PREPEND "${BISON_DIR}")

set(OPTIONS "")
if(KMPKG_TARGET_IS_WINDOWS)
    set(OPTIONS -Denable-xkbregistry=false)
endif()

kmpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${OPTIONS}
        -Denable-wayland=false
        -Denable-docs=false
        -Denable-tools=false
)
kmpkg_install_meson()
kmpkg_fixup_pkgconfig()
kmpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

if(KMPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

# Handle copyright
kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
endif()
