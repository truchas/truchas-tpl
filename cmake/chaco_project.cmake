if(SEARCH_FOR_CHACO)
  message(STATUS "Searching for a suitable Chaco library ...")
  find_package(CHACO)
endif()

if(CHACO_FOUND)
  list(APPEND projects_found "Chaco")
  add_custom_target(chaco)
else()
  list(APPEND projects_to_build "Chaco")
  externalproject_add(chaco
    PREFIX chaco
    URL ${TARFILE_DIR}/chaco-2.2-92a877b.tar.gz
    URL_MD5 6bda1639a465ca24f8f777becb70e35c
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
  if(BUILD_SHARED_LIBS)
    set(CHACO_LIBRARY "${CMAKE_INSTALL_PREFIX}/lib/libchaco${CMAKE_SHARED_LIBRARY_SUFFIX}")
  else()
    set(CHACO_LIBRARY "${CMAKE_INSTALL_PREFIX}/lib/libchaco${CMAKE_STATIC_LIBRARY_SUFFIX}")
  endif()
  set(CHACO_LIBRARIES "${CHACO_LIBRARY}")
endif()
