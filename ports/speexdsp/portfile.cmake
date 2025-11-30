if(KMPKG_USE_HEAD_VERSION)
    kmpkg_from_gitlab(
        GITLAB_URL "https://gitlab.xiph.org"
        OUT_SOURCE_PATH SOURCE_PATH
        REPO xiph/speexdsp
        HEAD_REF master
    )
else()
    # Since the github repo is out-dated, use official download URL for release builds to reduce traffic to the Gitlab host
    kmpkg_download_distfile(ARCHIVE
        URLS "http://downloads.xiph.org/releases/speex/speexdsp-1.2.1.tar.gz"
        FILENAME "speexdsp-1.2.1.tar.gz"
        SHA512 41b5f37b48db5cb8c5a0f6437a4a8266d2627a5b7c1088de8549fe0bf0bb3105b7df8024fe207eef194096e0726ea73e2b53e0a4293d8db8e133baa0f8a3bad3
    )
    kmpkg_extract_source_archive(
        SOURCE_PATH
        ARCHIVE "${ARCHIVE}"
        SOURCE_BASE "1.2.1"
        PATCHES
            jitter_ctl.patch
    )
endif()

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

set(USE_SSE OFF)
if(KMPKG_TARGET_ARCHITECTURE STREQUAL "x64" OR KMPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    set(USE_SSE ON)
endif()
set(USE_NEON OFF)
if(KMPKG_TARGET_ARCHITECTURE STREQUAL "arm" OR KMPKG_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(USE_NEON ON)
endif()

kmpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
    -DUSE_SSE=${USE_SSE}
    -DUSE_NEON=${USE_NEON}
)

kmpkg_cmake_install()
kmpkg_copy_pdbs()

kmpkg_fixup_pkgconfig()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME "copyright")
