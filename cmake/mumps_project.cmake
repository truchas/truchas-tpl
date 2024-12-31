if(SEARCH_FOR_MUMPS)
  message(STATUS "Searching for a suitable MUMPS library ...")
  find_package(MUMPS)
endif()

if(MUMPS_FOUND)
  list(APPEND projects_found "mumps")
  add_custom_target(mumps)
else()
  list(APPEND projects_to_build "mumps")
  set(MUMPS_VERSION "5.7.3.1-21-fdd8339")
  externalproject_add(mumps
    DEPENDS scalapack
    PREFIX mumps
    URL ${TARFILE_DIR}/mumps-${MUMPS_VERSION}.tar.gz
    URL_MD5 0fb7cd539329f818899cfea2219c7cf5
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_CXX_COMPILER:PATH=${CMAKE_CXX_COMPILER}
               -D CMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
	       -D CMAKE_Fortran_COMPILER:PATH=${CMAKE_Fortran_COMPILER}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D BUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
	       -D CMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}
	       -D BUILD_SINGLE:BOOL=OFF
	       -D BUILD_COMPLEX16:BOOL=ON
	       -D metis:BOOL=ON
	       -D scalapack:BOOL=ON
	       -D MUMPS_BUILD_TESTING=OFF
	       -D url:PATH=${TARFILE_DIR}/MUMPS_5.7.3.tar.gz
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
  set(MUMPS_ROOT ${CMAKE_INSTALL_PREFIX})
endif()
