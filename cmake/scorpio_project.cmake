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
    URL ${TARFILE_DIR}/scorpio-2.2-9eb9117.tar.gz
    URL_MD5 480c3e18f511d0e4c57ef0e6f093f60e
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_C_COMPILER:PATH=${MPI_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
	       -D HDF5_C_LIBRARY:PATH=${HDF5_C_LIBRARIES}
	       -D HDF5_HL_LIBRARY:PATH=${HDF5_HL_LIBRARIES}
	       -D HDF5_INCLUDE_DIR:PATH=${HDF5_INCLUDE_DIRS}
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
