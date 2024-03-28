if(SEARCH_FOR_SCORPIO)
  message(STATUS "Searching for a suitable Scorpio library ...")
  find_package(Scorpio)
endif()

if(Scorpio_FOUND)
  list(APPEND projects_found "Scorpio")
else()
  list(APPEND projects_to_build "Scorpio")
  externalproject_add(scorpio
    DEPENDS hdf5
    PREFIX scorpio
    URL ${TARFILE_DIR}/scorpio-2.2-c9029aa.tar.gz
    URL_MD5 ca99767fac4ed853f5cf3d5afb0fdc86
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_C_COMPILER:PATH=${MPI_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
               -D HDF5_ROOT:PATH=${HDF5_ROOT}
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
  if(BUILD_SHARED_LIBS)
    set(SCORPIO_LIBRARY "${CMAKE_INSTALL_PREFIX}/lib/libscorpio${CMAKE_SHARED_LIBRARY_SUFFIX}")
  else()
    set(SCORPIO_LIBRARY "${CMAKE_INSTALL_PREFIX}/lib/libscorpio${CMAKE_STATIC_LIBRARY_SUFFIX}")
  endif()
  set(SCORPIO_LIBRARIES "${SCORPIO_LIBRARY}")
endif()
