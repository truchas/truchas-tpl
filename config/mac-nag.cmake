# Generic Linux with NAG Fortran and GNU C/C++

set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type")

set(CMAKE_C_COMPILER gcc CACHE STRING "C Compiler")
set(CMAKE_CXX_COMPILER g++ CACHE STRING "C++ Compiler")
set(CMAKE_Fortran_COMPILER nagfor CACHE STRING "Fortran Compiler")

# override the new -Werror default in apple/clang 12
set(CMAKE_C_FLAGS "-Wno-error=implicit-function-declaration" CACHE STRING "C compile flags")
set(CMAKE_Fortran_FLAGS "-u -O3" CACHE STRING "Fortran compile flags")

set(CMAKE_SHARED_LINKER_FLAGS
  "-Wl,-undefined -Wl,dynamic_lookup -Wl,-headerpad_max_install_names"
  CACHE STRING "Mac linker flags")
