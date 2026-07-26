list(APPEND projects_to_build "mumps")
set(MUMPS_VERSION "5.7.3.1-21-fdd8339")

set(mumps_lapack_vendor_arg)
if(MUMPS_LAPACK_VENDOR)
  string(REPLACE ";" "|" mumps_lapack_vendor "${MUMPS_LAPACK_VENDOR}")
  set(mumps_lapack_vendor_arg
      -D LAPACK_VENDOR:STRING=${mumps_lapack_vendor})
endif()

truchas_tpl_external_project(
  NAME mumps
  DISPLAY_NAME MUMPS
  VERSION ${MUMPS_VERSION}
  GENERATOR "Unix Makefiles"
  LIST_SEPARATOR "|"
  DEPENDS metis scalapack
  URL ${TARFILE_DIR}/mumps-${MUMPS_VERSION}.tar.gz
  URL_HASH SHA256=5a8a4e920e2db2ac53201665318bd42ea9385a9780bf387c6e18a019abad7513
  CMAKE_ARGS
    -D CMAKE_CXX_COMPILER:PATH=${MPI_CXX_COMPILER}
    -D CMAKE_C_COMPILER:PATH=${MPI_C_COMPILER}
    -D CMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
    -D CMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
    -D CMAKE_Fortran_COMPILER:PATH=${MPI_Fortran_COMPILER}
    -D CMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}
    -D BUILD_SINGLE:BOOL=OFF
    -D BUILD_COMPLEX16:BOOL=ON
    -D metis:BOOL=ON
    -D scalapack:BOOL=ON
    -D MUMPS_BUILD_TESTING:BOOL=OFF
    -D url:PATH=${TARFILE_DIR}/MUMPS_5.7.3.tar.gz
    ${mumps_lapack_vendor_arg}
)
set(MUMPS_ROOT ${CMAKE_INSTALL_PREFIX})
