# Builds both shared and static library; not controllable.

if(SEARCH_FOR_PORTAGE)
  message(STATUS "Searching for a suitable Portage library ...")
  find_package(Portage "2.2.0")
endif()

if(PORTAGE_FOUND)
  list(APPEND projects_found "Portage")
  add_custom_target(portage)
else()
  list(APPEND projects_to_build "Portage")
  set(PORTAGE_VERSION "2.2.0")
  externalproject_add(portage
    PREFIX portage
    URL ${TARFILE_DIR}/portage-${PORTAGE_VERSION}.tar.gz
    URL_MD5 9c2a2c4ab176e191ac6425c5d387031d
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_CXX_COMPILER:PATH=${CMAKE_CXX_COMPILER}
               -D CMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
  set(PORTAGE_INCLUDE_DIR "${CMAKE_INSTALL_PREFIX}/include")
  if(BUILD_SHARED_LIBS)
    set(PORTAGE_LIBRARY "${CMAKE_INSTALL_PREFIX}/lib64/libportage${CMAKE_SHARED_LIBRARY_SUFFIX}")
    set(WONTON_LIBRARY  "${CMAKE_INSTALL_PREFIX}/lib64/libwonton${CMAKE_SHARED_LIBRARY_SUFFIX}")
  else()
    set(PORTAGE_LIBRARY "${CMAKE_INSTALL_PREFIX}/lib64/libportage${CMAKE_STATIC_LIBRARY_SUFFIX}")
    set(WONTON_LIBRARY  "${CMAKE_INSTALL_PREFIX}/lib64/libwonton${CMAKE_STATIC_LIBRARY_SUFFIX}")
  endif()
  set(PORTAGE_INCLUDE_DIRS "${PORTAGE_INCLUDE_DIR}")
  set(PORTAGE_LIBRARIES "${PORTAGE_LIBRARY}" "${WONTON_LIBRARY}")
endif()
