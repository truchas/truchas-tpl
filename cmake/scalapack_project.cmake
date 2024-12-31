if(SEARCH_FOR_SCALAPACK)
  message(STATUS "Searching for a suitable ScalaPACK library ...")
  find_package(SCALAPACK)
endif()

if(SCALAPACK_FOUND)
  list(APPEND projects_found "scalapack")
  add_custom_target(scalapack)
else()
  list(APPEND projects_to_build "scalapack")
  set(SCALAPACK_VERSION "2.2.1")
  externalproject_add(scalapack
    PREFIX scalapack
    URL ${TARFILE_DIR}/scalapack-${SCALAPACK_VERSION}.tar.gz
    URL_MD5 58f32e40b0082012f1564c7f712a0ba1
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
	       -D CMAKE_Fortran_COMPILER:PATH=${CMAKE_Fortran_COMPILER}
	       -D CMAKE_Fortran_FLAGS:STRING=${CMAKE_Fortran_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D BUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
	       -D SCALAPACK_BUILD_TESTS:BOOL=NO
    PATCH_COMMAND patch -p1 --input=${TARFILE_DIR}/scalapack-cmake.patch
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
  set(MUMPS_ROOT ${CMAKE_INSTALL_PREFIX})
endif()
