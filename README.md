Truchas Third-Party Library Superbuild
------------------------------------------------------------------------------
This repository builds third-party libraries for Truchas from vendored source
archives and installs them into a single prefix. It is a convenience for
creating a coherent Truchas TPL installation; it is not required by Truchas and
it is not a general package discovery layer.

The superbuild always builds the selected vendored packages. It does not search
for or reuse system installations. If you want Truchas to use system-provided
or individually installed TPLs, configure Truchas directly and set
`CMAKE_PREFIX_PATH` as needed so Truchas can run its own per-package
`find_package` checks.

### Vendored Packages
The standard Truchas TPL set built by this repository is HDF5, NetCDF, Exodus,
fVTKHDF, HYPRE, Petaca, YAJL, METIS, Chaparral, and Scorpio. MUMPS and
ScaLAPACK are enabled by default. Portage and Wonton are optional and disabled
by default.

Chaparral and Scorpio are Truchas-maintained modified versions of external
libraries. Their source repositories are:

* Chaparral: https://gitlab.com/truchas/chaparral/
* Scorpio: https://gitlab.com/truchas/scorpio/

The source archives are in the `tarfiles` subdirectory. See `TPL-LICENSES.md`
for exact versions, licenses, and upstream source locations.

### Supported Compilers
Although the TPLs can individually be built with many different compilers, it is
strongly recommended that they be built with the same compilers used to build
Truchas. The Fortran compiler vendor must match. See the `BUILDING` file in the
Truchas distribution for the supported Truchas compiler set.

### Build
This project requires CMake 3.20 or newer. The provided presets use the Ninja
generator by default.

Run preset commands from the repository root. The preset chooses the build
directory, for example `build/linux-gcc`.

    $ cmake --preset linux-gcc -D CMAKE_INSTALL_PREFIX=/path/to/truchas-tpl
    $ cmake --build --preset linux-gcc

The `CMakePresets.json` file contains examples for supported compilers. If none
of those are right for your situation, create your own preset or define the
variables directly on the CMake command line with `-D` options.

By default the packages are installed into the `install` subdirectory of the
build directory. Add `-D CMAKE_INSTALL_PREFIX=<tpl_dir>` to the configure
command to specify a different install prefix. The install prefix must be an
absolute path.

No separate `make install` or `cmake --install` command is needed. The selected
packages are built and installed by the build command. Moving the libraries
after they are installed will often break things, so choose the final install
prefix before building.

`cmake --build --preset ...` invokes Ninja automatically when the build
directory was configured with the preset default. You can run Ninja directly if
needed, for example:

    $ ninja -C build/linux-gcc

#### Building Without Ninja
On systems where Ninja is not available, override the preset generator during
the initial configure step:

    $ cmake --preset linux-gcc -G "Unix Makefiles" -D CMAKE_INSTALL_PREFIX=/path/to/truchas-tpl
    $ cmake --build --preset linux-gcc --parallel

The build directory must be fresh, because CMake cannot switch an existing
build directory from Ninja to Makefiles in place.

### Build Options
The main build options are:

* `TRUCHAS_TPL_BUILD_SHARED`: build shared libraries where supported. The
  default is `ON`. Setting this to `OFF` requests static libraries, which
  generally doesn't work currently except on platforms that provide a "full"
  set of static system libraries, such as Cray systems.
* `TRUCHAS_TPL_BUILD_MUMPS`: build MUMPS and ScaLAPACK. The default is `ON`.
* `TRUCHAS_TPL_BUILD_PORTAGE`: build Portage and Wonton. The default is `OFF`.
  Portage is picky about compilers and dependent libraries, and it may be
  difficult to get it to compile without error.

The older option names `BUILD_SHARED_LIBS`, `BUILD_MUMPS`, and `BUILD_PORTAGE`
are still accepted for compatibility.

### Using the Installed Prefix
The build generates passive provenance files in the install prefix:

    share/truchas-tpl/manifest.json
    share/truchas-tpl/build-summary.txt

These files are for support and reproducibility. They are not used by Truchas
to find dependencies.

To use a truchas-tpl installation when configuring Truchas, add the install
prefix to `CMAKE_PREFIX_PATH` and let Truchas run its normal per-package
`find_package` checks.

### Notes For Manual TPL Builds
These notes are for building or obtaining TPLs outside this superbuild. If you
follow that route, skip this repository and configure Truchas directly against
the resulting installations.

#### HDF5
* Only the C interface is needed.
* The high-level library (HL) is needed.
* Be sure to enable parallel HDF5.

#### NetCDF
* Use `--with-netcdf-4`.
* We only use the C interface; neither the separately-distributed Fortran nor
  C++ libraries are needed.

#### Exodus
* We build the Exodus component from SEACAS.

#### HYPRE
* Only the C interface is needed (`--disable-fortran`).
* Use `--with-MPI`.
* Use `--without-fei`; it is not needed and may have compilation problems.
* Version 2.15.1 or newer is required. Note that numerical differences in
  different versions may produce enough variation in the output to cause some
  regression tests to report failures.

#### Portage
* We currently use version 3.0.0. The Portage API is unstable, so other
  versions are unlikely to work.

#### MUMPS
* Leave `MUMPS_LAPACK_VENDOR` unset to use MUMPS's default LAPACK search.
  Supported vendors are `Netlib`, `OpenBLAS`, `MKL`, `MKL64`, `AOCL`, and
  `Atlas`.
* Modifiers may be combined with a vendor as a semicolon-separated CMake list,
  for example `-DMUMPS_LAPACK_VENDOR='MKL;OpenMP'`. Supported modifiers are
  `STATIC`, `LAPACKE`, `LAPACK95`, `OpenMP`, and `TBB`.
