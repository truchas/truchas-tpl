if(SEARCH_FOR_FVTKHDF)
  message(STATUS "Searching for a suitable fvtkhdf library ...")
  find_package(fVTKHDF)
endif()

if(fVTKHDF_FOUND)
  list(APPEND projects_found "fVTKHDF")
else()
  list(APPEND projects_to_build "fVTKHDF")
  externalproject_add(fvtkhdf
    DEPENDS hdf5
    PREFIX fvtkhdf
    URL ${TARFILE_DIR}/fvtkhdf-0.5.1.tar.gz
    URL_MD5 898a90431ad777112b686f6e9221b80c
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_Fortran_COMPILER:PATH=${CMAKE_Fortran_COMPILER}
               -D CMAKE_Fortran_FLAGS:STRING=${CMAKE_Fortran_FLAGS}
               -D CMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
               -D ENABLE_STD_MOD_PROC_NAME=${ENABLE_STD_MOD_PROC_NAME}
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
endif()
