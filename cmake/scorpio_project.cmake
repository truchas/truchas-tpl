list(APPEND projects_to_build "Scorpio")

if(CMAKE_C_COMPILER_ID MATCHES "GNU")
  set(scorpio_c_flags "${CMAKE_C_FLAGS} -std=gnu90")
elseif(CMAKE_C_COMPILER_ID MATCHES "Clang")
  set(scorpio_c_flags "${CMAKE_C_FLAGS} -std=gnu90 -Wno-error=incompatible-pointer-types")
elseif(CMAKE_C_COMPILER_ID MATCHES "IntelLLVM")
  set(scorpio_c_flags "${CMAKE_C_FLAGS} -Wno-error=incompatible-pointer-types")
else()
  set(scorpio_c_flags "${CMAKE_C_FLAGS}")
endif()

truchas_tpl_external_project(
  NAME scorpio
  DISPLAY_NAME Scorpio
  VERSION 2.2
  DEPENDS hdf5
  URL ${TARFILE_DIR}/scorpio-2.2-c9029aa.tar.gz
  URL_HASH SHA256=ea0fd7b30e18d0166ad5a5fafd0918d50796d6fba0c6d6af1b24185b8a7e1dca
  CMAKE_ARGS
    -D CMAKE_C_COMPILER:PATH=${MPI_C_COMPILER}
    -D CMAKE_C_FLAGS:STRING=${scorpio_c_flags}
    -D HDF5_ROOT:PATH=${HDF5_ROOT}
)

if(BUILD_SHARED_LIBS)
  set(SCORPIO_LIBRARY "${CMAKE_INSTALL_PREFIX}/lib/libscorpio${CMAKE_SHARED_LIBRARY_SUFFIX}")
else()
  set(SCORPIO_LIBRARY "${CMAKE_INSTALL_PREFIX}/lib/libscorpio${CMAKE_STATIC_LIBRARY_SUFFIX}")
endif()
set(SCORPIO_LIBRARIES "${SCORPIO_LIBRARY}")
