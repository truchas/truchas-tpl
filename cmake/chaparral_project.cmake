if(SEARCH_FOR_CHAPARRAL)
  message(STATUS "Searching for a suitable Chaparral library ...")
  find_package(Chaparral)
endif()

if(Chaparral_FOUND)
  list(APPEND projects_found "Chaparral")
else()
  list(APPEND projects_to_build "Chaparral")
  externalproject_add(chaparral
    PREFIX chaco
    URL ${TARFILE_DIR}/chaparral-3.2-747434a.tar.gz
    URL_MD5 3e29076e24acf9f4cb85680296b58a8d
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
