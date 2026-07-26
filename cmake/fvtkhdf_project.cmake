if(SEARCH_FOR_FVTKHDF)
  message(STATUS "Searching for a suitable fvtkhdf library ...")
  find_package(fVTKHDF)
endif()

if(fVTKHDF_FOUND)
  list(APPEND projects_found "fVTKHDF")
else()
  list(APPEND projects_to_build "fVTKHDF")
  if(CMAKE_Fortran_COMPILER_ID MATCHES "NAG")
    set(CMAKE_Fortran_COMPILER mpifort)
    set(CMAKE_C_COMPILER mpicc)
  endif()
  externalproject_add(fvtkhdf
    DEPENDS hdf5
    PREFIX fvtkhdf
    URL ${TARFILE_DIR}/fvtkhdf-0.6.1.tar.gz
    URL_MD5 35aba838644deeceb9404a96e53b055c
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}
               -D CMAKE_Fortran_COMPILER:PATH=${CMAKE_Fortran_COMPILER}
               -D CMAKE_Fortran_FLAGS:STRING=${CMAKE_Fortran_FLAGS}
               -D CMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
	       -D USE_MPI_F08:BOOL=NO
               -D ENABLE_STD_MOD_PROC_NAME=${ENABLE_STD_MOD_PROC_NAME}
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
endif()
