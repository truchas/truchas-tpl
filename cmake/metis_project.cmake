if(SEARCH_FOR_METIS)
  message(STATUS "Searching for a suitable METIS library ...")
  find_package(METIS 5.1.0)
endif()

if(METIS_FOUND)
  list(APPEND projects_found "METIS")
else()
  list(APPEND projects_to_build "METIS")
  set(METIS_VERSION "5.1.0")
  if(BUILD_SHARED_LIBS)
    set(metis_shlib_flag 1)
  else()
    set(metis_shlib_flag 0)
  endif()
  externalproject_add(metis
    PREFIX metis
    URL ${TARFILE_DIR}/metis-${METIS_VERSION}.tar.gz
    URL_MD5 5465e67079419a69e0116de24fce58fe
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D SHARED=${metis_shlib_flag}
               -D GKLIB_PATH=${CMAKE_BINARY_DIR}/metis/src/metis/GKlib
# The above setting of GKLIB_PATH is totally f*cked up and I don't know
# how to do it properly. The underlying problem is that the metis build
# system is an abomination, using make to run cmake. The approach below
# should work -- it does from the command line -- but from here it fails
# at the very end of the build step after successfully building metis,
# when it tries to make a target 's'. I have no clue where that comes from.
#    CONFIGURE_COMMAND $(MAKE) config prefix=${CMAKE_INSTALL_PREFIX}
#                      cc=${CMAKE_C_COMPILER} shared=${metis_shlib_flag}
#    BUILD_COMMAND $(MAKE)
#    BUILD_IN_SOURCE 1
    PATCH_COMMAND patch -p1 < ${TARFILE_DIR}/metis-cmake-version.patch
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
endif()
