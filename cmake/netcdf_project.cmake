if(SEARCH_FOR_NETCDF)
  message(STATUS "Searching for a suitable NetCDF library ...")
  find_package(NetCDF "4.3")
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
  set(NETCDF_VERSION "4.4.1.1")

  externalproject_add(netcdf
    DEPENDS hdf5
    PREFIX netcdf
    URL ${TARFILE_DIR}/netcdf-${NETCDF_VERSION}.tar.gz
    URL_MD5 503a2d6b6035d116ed53b1d80c811bda
    CMAKE_ARGS -D CMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
               -D CMAKE_C_COMPILER:PATH=${MPI_C_COMPILER}
               -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
               -D CMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
               -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
	       -D ENABLE_EXAMPLES:BOOL=OFF
	       -D HDF5_C_LIBRARY:PATH=${HDF5_C_LIBRARIES}
	       -D HDF5_HL_LIBRARY:PATH=${HDF5_HL_LIBRARIES}
	       -D HDF5_INCLUDE_DIR:PATH=${HDF5_INCLUDE_DIRS}
	       -D ENABLE_DAP:BOOL=OFF
    PATCH_COMMAND patch -p1 < ${TARFILE_DIR}/netcdf-large-model.patch
    LOG_UPDATE 1
    LOG_DOWNLOAD 1
    LOG_CONFIGURE 1
    LOG_BUILD 1
    LOG_INSTALL 1
    )

  # These FindNetCDF variables are needed to configure exodus.
  set(NETCDF_C_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include)
  if(BUILD_SHARED_LIBS)
    set(NETCDF_C_LIBRARY ${CMAKE_INSTALL_PREFIX}/lib/libnetcdf${CMAKE_SHARED_LIBRARY_SUFFIX})
  else()
    set(NETCDF_C_LIBRARY ${CMAKE_INSTALL_PREFIX}/lib/libnetcdf${CMAKE_STATIC_LIBRARY_SUFFIX})
  endif()
endif()
