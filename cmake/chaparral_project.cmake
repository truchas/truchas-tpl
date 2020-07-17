if(SEARCH_FOR_CHAPARRAL)
  message(STATUS "Searching for a suitable Chaparral library ...")
  find_package(CHAPARRAL)
endif()

if(CHAPARRAL_FOUND)
  list(APPEND projects_found "Chaparral")
  add_custom_target(chaparral)
else()
  list(APPEND projects_to_build "Chaparral")
  externalproject_add(chaparral
    PREFIX chaco
    URL ${TARFILE_DIR}/chaparral-3.2-747434a.tar.gz
    URL_MD5 4b35f337ec93f08e6c0b8ec6e9fe9c0e
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_C_COMPILER:PATH=${MPI_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
  if(BUILD_SHARED_LIBS)
    set(CHAPARRAL_LIBRARY "${CMAKE_INSTALL_PREFIX}/lib/libVF${CMAKE_SHARED_LIBRARY_SUFFIX}")
  else()
    set(CHAPARRAL_LIBRARY "${CMAKE_INSTALL_PREFIX}/lib/libVF${CMAKE_STATIC_LIBRARY_SUFFIX}")
  endif()
  set(CHAPARRAL_LIBRARIES "${CHAPARRAL_LIBRARY}")
endif()
