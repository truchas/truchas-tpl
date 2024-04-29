if(SEARCH_FOR_HYPRE)
  message(STATUS "Searching for a suitable HYPRE library ...")
  find_package(HYPRE 2.29.0)
  if(HYPRE_FOUND)
    if(NOT HYPRE_IS_PARALLEL)
      set(HYPRE_FOUND False)
      message(STATUS "Require parallel HYPRE library but found unsuitable serial library")
    endif()
  endif()
endif()

if(HYPRE_FOUND)
  list(APPEND projects_found "HYPRE")
else()
  list(APPEND projects_to_build "HYPRE")
  set(HYPRE_VERSION "2.31.0")
  externalproject_add(hypre
    PREFIX hypre
    URL ${TARFILE_DIR}/hypre-${HYPRE_VERSION}.tar.gz
    URL_MD5 3e6a9cea4e87d5d87301c95200d28242
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
               -D HYPRE_ENABLE_SHARED=${BUILD_SHARED_LIBS}
               -D CMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D HYPRE_WITH_MPI:BOOL=ON
               -D HYPRE_ENABLE_FEI:BOOL=OFF
    SOURCE_SUBDIR src
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
  )
endif()
