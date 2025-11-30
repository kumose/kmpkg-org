kmpkg_download_distfile(ARCHIVE
  URLS "https://www.scintilla.org/scintilla556.zip"
  FILENAME "scintilla556.zip"
  SHA512 8e845a94379fff88222fa9e4e5f534f62595420dd933166e4d9cc67b197c79f578405cb020892142ead1afd85bd42f1dc4361a339134a087e14760ff33d0a1cf
)

if (KMPKG_LIBRARY_LINKAGE STREQUAL "static")
  list(APPEND PATCHES 0001-static-lib.patch)
endif()

if(KMPKG_CRT_LINKAGE STREQUAL "static")
  list(APPEND PATCHES 0002-static-crt.patch)
endif()

kmpkg_extract_source_archive(
  SOURCE_PATH
  ARCHIVE ${ARCHIVE}
  SOURCE_BASE 5.5.6
  PATCHES ${PATCHES}
)

kmpkg_install_msbuild(
  SOURCE_PATH "${SOURCE_PATH}"
  PROJECT_SUBPATH Win32/Scintilla.vcxproj
)

kmpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/License.txt")
file(INSTALL "${SOURCE_PATH}/include/" DESTINATION "${CURRENT_PACKAGES_DIR}/include/${PORT}" FILES_MATCHING PATTERN "*.*")
