kmpkg_from_gitlab(
    GITLAB_URL https://gitlab.freedesktop.org/
    OUT_SOURCE_PATH SOURCE_PATH
    REPO slirp/libslirp
    REF "v${VERSION}"
    SHA512 503035b24f657f610398c23656b0783bc15ec08d020e42085fd4f558a642d067dab21dd339d0f243f8f34347c3bc82edf22e6a9fc8164bfdfb9bfd7878af9fae
    HEAD_REF master
)

if(KMPKG_HOST_IS_WINDOWS)
    kmpkg_acquire_msys(MSYS_ROOT)
    kmpkg_add_to_path("${MSYS_ROOT}/usr/bin")
endif()

kmpkg_configure_meson(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${OPTIONS}
)

kmpkg_install_meson(ADD_BIN_TO_PATH)

kmpkg_fixup_pkgconfig()

kmpkg_copy_pdbs()

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/COPYRIGHT")
