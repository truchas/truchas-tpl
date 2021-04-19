if(SEARCH_FOR_NETCDF)
  message(STATUS "Searching for a suitable NetCDF library ...")
  find_package(NetCDF "4.8")
  if(NETCDF_FOUND)
    if(NOT NETCDF_HAS_NC4)
      message(STATUS "Found unsuitable NetCDF without required netcdf-4 feature")
      set(NETCDF_FOUND False)
    endif()
  endif()
endif()

if(NETCDF_FOUND)
  list(APPEND projects_found "NetCDF")
else()
  list(APPEND projects_to_build "NetCDF")
  set(NETCDF_VERSION "4.8.0")

  externalproject_add(netcdf
    DEPENDS hdf5
    PREFIX netcdf
    URL ${TARFILE_DIR}/netcdf-c-${NETCDF_VERSION}.tar.gz
    URL_MD5 a1e31625e2f270aa8044578d7320962c
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_C_COMPILER:PATH=${MPI_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
	       -D ENABLE_EXAMPLES:BOOL=OFF
	       -D ENABLE_DAP:BOOL=OFF
               -D HDF5_ROOT:PATH=${HDF5_ROOT}
    #PATCH_COMMAND patch -p1 < ${TARFILE_DIR}/netcdf-large-model.patch
    LOG_UPDATE 1
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
    )

  set(netCDF_ROOT ${CMAKE_INSTALL_PREFIX})
endif()
