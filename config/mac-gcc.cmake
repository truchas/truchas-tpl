# Mac with GNU C/C++/Fortran

set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type")

set(CMAKE_C_COMPILER $ENV{CC} CACHE STRING "C Compiler")
set(CMAKE_CXX_COMPILER $ENV{CPP} CACHE STRING "C++ Compiler")
set(CMAKE_Fortran_COMPILER $ENV{FC} CACHE STRING "Fortran Compiler")

# Additional flags to the default CMAKE_<lang>_FLAGS_<build_type> flags
set(CMAKE_Fortran_FLAGS "-fimplicit-none" CACHE STRING "Fortran compile flags")

set(CMAKE_SHARED_LINKER_FLAGS
  "-Wl,-undefined -Wl,dynamic_lookup -Wl,-headerpad_max_install_names"
  CACHE STRING "Mac linker flags")
