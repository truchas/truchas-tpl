list(APPEND projects_to_build "METIS")
set(METIS_VERSION "5.1.0")

if(BUILD_SHARED_LIBS)
  set(metis_shlib_flag 1)
else()
  set(metis_shlib_flag 0)
endif()

truchas_tpl_external_project(
  NAME metis
  DISPLAY_NAME METIS
  VERSION ${METIS_VERSION}
  URL ${TARFILE_DIR}/metis-${METIS_VERSION}.tar.gz
  URL_HASH SHA256=76faebe03f6c963127dbb73c13eab58c9a3faeae48779f049066a21c087c5db2
  CMAKE_ARGS
    -D CMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}
    -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
    -D SHARED=${metis_shlib_flag}
    -D GKLIB_PATH=${CMAKE_BINARY_DIR}/metis/src/metis/GKlib
  PATCH_COMMAND patch -p1 < ${TARFILE_DIR}/metis-cmake-version.patch
)
