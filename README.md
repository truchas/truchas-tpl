Truchas Third-Party Library Superbuild
------------------------------------------------------------------------------
This directory contains a cmake system for building most of the third party
packages needed by Truchas.  While we endeavor to make this as robust as
possible, especially for the platforms we use and test on, it is inevitable
that this will not work for some people.  In that circumstance remember that
you can build them manually (or obtain them otherwise); you don't have to
make this system work.  All that matters is that the Truchas cmake step can
find them.

These are the third-party libraries that Truchas requires and where they
can be obtained. This repository contains tar files of specific versions
of each as a convenience.

* HDF5: https://www.hdfgroup.org/downloads/hdf5/
* NetCDF: https://www.unidata.ucar.edu/downloads/netcdf/
* Exodus: https://github.com/gsjaardema/seacas/
* Hypre: https://github.com/hypre-space/hypre/
* Petaca: https://github.com/nncarlson/petaca/
* YAJL: https://lloyd.github.io/yajl/
* Metis: http://glaros.dtc.umn.edu/gkhome/metis/metis/download

Truchas requires modified versions of the following libraries, which can
be obtained from indicated repositories. This repository also contains tar
files of the modified versions of each as a convenience.

* Chaco: https://gitlab.com/truchas/chaco/
* Chaparral: https://gitlab.com/truchas/chaparral/
* Scorpio: https://gitlab.com/truchas/scorpio/

Optional third-party libraries that Truchas may use:

* Portage: https://github.com/laristra/portage/

To build (or find) Portage include the CMake option `-D BUILD_PORTAGE=ON`.
This library is extra picky about compilers and dependent libraries, and
it may be difficult to get it to compile without error.

#### Supported compilers
Although individually the TPLs can be built with any number of different
compilers, it is strongly recommended that they be built with the same
compilers used to build Truchas (the Fortran compiler vendor *must* be the
same). Please see the BUILDING file in the Truchas distribution for a list
of compilers supported by Truchas.

### Quick Start Guide
The packages that can be built are HDF5, NetCDF, Exodus, HYPRE, Petaca,
YAJL, Chaco, Chaparral, Scorpio, METIS, and Portage. Compressed tar files
of their source distributions can be found in the `tarfiles` subdirectory.

The basic procedure is simple (when it works). You create a build directory,
run cmake from that directory, and then run make. What you choose for a build
directory is irrelevant (other than it can't be this directory).  You will
also provide cmake command line arguments that customize the build in several
ways.  Here's an example:

    $ mkdir build
    $ cd build
    $ cmake -C ../config/linux-intel.cmake ..
    $ make

The `-C` argument preloads the cmake cache with settings from the following
file.  The `config` subdirectory contains many examples.  If none of those
are right for your situation, create your own, or simply define the various
variables directly on the cmake command line (using the `-D` flag).  By
default the packages are installed into the `install` subdirectory of the
build directory. Add `-D CMAKE_INSTALL_PREFIX=<tpl_dir>` to the cmake
command line to specify a different directory (replace `<tpl_dir>`
with the directory path; it must be an absolute path.)  Note that no `make
install` command is necessary; the packages are automatically installed by the
`make` command.  Also note that moving the libraries after they are installed
will often break things, so it is better to decide where you want them before
starting.

By default cmake will configure the build of all packages. You can have cmake
search for and use an existing installation of a package by setting
`-D SEARCH_FOR_<pkg>=yes` on the cmake command line.  Here `<pkg>` can be
`HDF5`, `NETCDF`, `EXODUS`, `HYPRE`, `YAJL`, `PETACA`, `METIS`, or `PORTAGE`.
If it cannot find a suitable version it will go ahead and configure the
build of the package. Note that that when searching, cmake always looks first
in the installation directory.

Another command line variables is `ENABLE_SHARED`.  The default is `yes`.
Setting `ENABLE_SHARED` to `no`, meaning find and build static libraries,
generally doesn't work currently except on platforms that provide a "full"
set of static system libraries (Cray, for example).

You may optionally use `ninja` instead of `make`; the main benefit is that
Ninja builds in parallel by default, while `make -jX` will not build the
TPL packages in parallel. To do so, you need to add a flag to the cmake
command line, and call `ninja` instead of `make`.

    $ cmake -G Ninja <other flags>
    $ ninja

### Package Configuration Notes
If you find you have to build some packages manually (or obtain pre-built
ones), here are some points to keep in mind.  Also look at the files in the
`cmake` directory to see how we are configuring them.

#### HDF5
* Only the C interface is needed.
* The high-level library (HL) is needed.
* Be sure to enable parallel HDF5.

#### NetCDF
* Use `--with-netcdf-4`
* We only use the C interface; neither the separately-distributed Fortran
  nor C++ libraries are needed.

#### Exodus
* We use and test with a relative old version 5.14.  There are reported
  incompatibilities with current 6.x versions.

#### HYPRE
* Only the C interface is needed (`--disable-fortran`)
* Use `--with-MPI`.
* Use `--without-fei`; it is not needed and may have compilation problems.
* Version 2.15.1 or newer is required. Note that numerical differences in
  different versions may produce enough variation in the output to cause
  some regression tests to report failures.

#### Portage
* We currently use version 3.0.0. The Portage API is unstable, so other
  versions are unlikely to work.
