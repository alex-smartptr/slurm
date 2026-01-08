# New Build System

Key advantages:

- Faster builds. (Much faster incremental builds.)
- Switch between debug/release builds without having to reconfigure.
- Simpler user interface.


## Getting started

1. Run `./configure` as usual.

2. `make -s`

3. That's it. All `./configure` flags and settings are respected by the new system.

You can still use the old Automake build if you want. Just explicitly specify the top-level Makefile: `make -f Makefile`.


## Invoking make - options

- **Verbose output.** If you want to see everything that's being executed, just omit the `-s` ("silent") flag.

    > make

- **Optimised build.** The default is a developer build with debug symbols. To build optimised binaries, without debug symbols, set the variable `DEBUG=0`. 

    > make -s DEBUG=0

- **Parallel builds.** Make's `-j` flag works as usual.

    > make -j$(nproc) -s
    
    Or even...
    > alias make="make -j$(nproc)"
    > make -s

- **Unit tests.** The `check` target runs unit tests.

    > make -s check

- **Clean build.** The `clean` target removes all generated files. (All generated files are placed in a top-level directory called `build/` or `build-debug/`, so you can manually clean-up by just deleting these directories.

    > make clean

- **Install/Uninstall.** The normal `install` and `uninstall` targets work as expected.

    > make -s install


## Modify the build.

The top-level makefile is `GNUmakefile`. Build definitions are written to files called `ALL.mk` in each source code directory. Each makefile is expected to `include` the `ALL.mk` files of each of its subdirectories.


### Example: Add an executable.

A simple example of an executable definitions is `sreport` in `src/sreport/ALL.mk`:

    INSTALL_BIN += sreport

    sreport.CFILES := $(call FileList,\
            sreport.c \
            cluster_reports.c \
            job_reports.c \
            user_reports.c \
            resv_reports.c \
            common.c \
    )

    sreport.CFILES_EXTRA = $(slurmfull.CFILES)
    sreport.LDLIBS := $(READLINE_LIBS)

Here's an explanation of each line.

- **`INSTALL_BIN +=`** - Add a new target "sreport" to the list of installable programs. (You can also use INSTALL_SBIN, for programs that will be installed in `{prefix}/sbin/`, and EXE, for programs that will be built but not installed.

- **`sreport.CFILES :=`** - List the C files that are to be compiled and linked into `sreport`. The first part of the variable name matches the new target. Filenames must be relative to the top level build directory (e.g. `src/sreport/sreport.c`), the function `FileList` is provided to help get the paths right. **Must be "early bound" - using `:=`.**

- **`sreport.CFILES_EXTRA =`** - List of extra common C files that are also compiled and linked into `sreport`. These will usually be collections of C files that the old build system would have linked into intermediate libraries. **Must be "late bound" using `=`** - that's because we don't want to worry about the order in which `ALL.mk` files are read. Late binding means that the value is only checked when it's actually used.

- **`sreport.LDLIBS :=`** - Set extra linker flags for `sreport`.

In general, a target is defined by adding it to the proper category, and then customised by setting target-specific values.

> [!WARNING]
> It's crucial that you only `include` other makefiles at the very end of your `ALL.mk` file. Otherwise the helper functions `FileList` and `$(Here)` will produce incorrect file paths.


### Target Categories

**`INSTALL_BIN`** - program that is to be installed in `{prefix}/bin`.

**`INSTALL_SBIN`** - program that is to be installed in `{prefix}/sbin`.

**`PLUGIN`** - shared library to be installed in `{prefix}/lib/slurm`.

**`SOLIB`** - shared library to be installed in `{prefix}/lib`.

**`TEST`** - test program to be run during `make -s check`. Tests are considered to pass if their exit code is 0.

**`DUMMY`** - dummy target. This category exists simply to link target-specific values with common code. For example, if some common code requires a pre-processor macro to be set.

Anything that can be listed on the make command line is a "target". These are symbolic names that do not exist as concrete files. For example `INSTALL_BIN += foo` defines a target called `foo`. But the actual program that is compiled and linked has the filename `build-debug/bin/foo`.


### Available target-specific values.

These are all named `<target>.<value>`. In general they should be set by early binding (using `:=`).

**`<target>.CFILES`** - List the C files that are to be associated with the target. Should always be relative path from the root build directory. Use the function `FileList`, or the value `$(Here)` to assist.

**`<target>.CFILES_EXTRA`** - For shared code defined elsewhere that multiple targets link against. List of common C files that do not belong to the target, but which are to be linked into the target. Target-specific values (`CPPFLAGS`, `CFLAGS`, etc) do **not** apply the the files listed in `CFILES_EXTRA`.

Preprocessor and compiler settings: these values ONLY apply to `<target>.CFILES`, **not** to `<target>.CFILES_EXTRA`:

**`<target>.CPPINCLUDES`** - Include paths to be set on the compiler command line. Each entry is prefixed with `-I`.

**`<target>.CPPDEFINES`** - Preprocessor macros to be set on the compiler command line. Each entry is prefixed with `-D`.

**`<target>.CPPFLAGS`** - Preprocessor flags to be set on the compiler command line.

**`<target>.CFLAGS`** - Flags to be set on the **compiler and linker** command lines.

Linker settings:

**`<target>.LDFLAGS`** - Flags to be set on the linker command line.

**`<target>.LDLIBS`** - Flags to be set on the linker command line. Generally this value should only contain library specifications (`-l<lib>` on GCC). Other flags can slip in though, especially `-L`. This value is added at the end of the linker command line, after the object files and archives have been listed.

**`<target>.LIBS`** - List of libraries to send to the linker. Each entry is prefixed with `-l`.

Other settings:

**`<target>.ARGS`** (`TEST` target only) - Command-line arguments to be passed to the test.

**`<target>.ENVIRON`** (`TEST` target only) - Environment variables to be set during the test's execution.

**`<target>.VERSION`** (`SOLIB` target only) - MAJOR.MINOR.MICRO version number of the shared library. Control the soname applied to the shared library, and the final installed file- and symlink-names.


## Conventions

Names in `ALL_CAPS` are generally set by the user to influence the behaviour of the build system.

Names in `CamelCase`, or sometimes `lowercase` are generally functions or late-bound templates that can be used to assist in defining targets.

Names that start with a single underscore (`_example`) are available to the user. They cannot be guaranteed to be unique, so make sure that the value is set and used within a single `ALL.mk` file.

Names that start with a double underscore (`__example`) are **reserved** for the build system.


## Introduction to the code

The library of `make` routines is located in the new `mk/` directory. `mk/functions.mk` contains some functions that users might find useful.

The main makefile is `GNUmakefile`. That's chosen because GNU Make uses it as the first priority, so the old build system (which uses the name `Makefile`) can co-exist with the new.  If you want to use the old build, then specify it with `make -f Makefile`.

`./configure` writes all autoconf variables into `config.mk`, from where they are available to your make code. In particular, Automake switches (e.g. "HAVE_JSON") are either set to 1, or not set. So user code can test them with make code like this:

    ifdef HAVE_JSON
      PLUGIN += json_plugin
      json_plugin.CFILES := $(Here)/json_plugin.c
      json_plugin.CPPFLAGS := $(JSON_CPPFLAGS)
      json_plugin.LDLIBS := $(JSON_LIBS)
    endif

All generated files are written to a single build directory, called either `build/` or `build-debug/`. The source-code tree is left pristine.

This build system does not use intermediate libraries. Historically, those were used to work around command-line length limitations. Modern shells don't have that problem, so we can simply pass all objects to the linker directly.

This build system does not use an internal shared library with common code (`libslurmfull.so`). Historically that was used to reduce installation size on systems with limited disk space. Executable sizes are relatively trivial on modern systems, so we don't need that extra level of complexity.

Furthermore, static linking every executable has a performance benefit (no PIC code), and allows link-time optimisation (LTO) and profile-guided optimisation (PGO) to maximally optimise each executable's code for its own use-case.

Extra target categories `EXE` (programs that are not installed) and `LIB` (static libraries) are present in the code, but not currently used.


### Useful functions and late-bound variables

Most of these are defined in `mk/functions.mk`

**`$(Here)`** - returns the relative path to the current `ALL.mk` file. Useful for converting a single file-name into the full path. It's vital to use the value immediately (`:=`), as it changes depending upon the context.

Moreover, `$(Here)` returns incorrect values after another makefile has been included. For this reason, always leave `include <makefile>` lines until the end of your file.

Example:

    In src/foo/ALL.mk,
    
        foo.CFILES := $(Here)/a.c
    
    ...is equivalent to...
    
        foo.CFILES := src/foo/a.c


**`FileList`** - make function that prefixes a collection of filenames with `$(Here)`.

Use as either `$(call FileList,FILES)` or `$(call FileList,SUBDIR,FILES)`.

Example 1:

    In src/foo/ALL.mk,
    
        foo.CFILES := $(call FileList, a.c b.c c.c)
    
    ...is equivalent to...
    
        foo.CFILES := src/foo/a.c src/foo/b.c src/foo/c.c

Example 2:

    In src/foo/ALL.mk,
    
        foo.CFILES := $(call FileList, bar/, a.c b.c c.c)
    
    ...is equivalent to...
    
        foo.CFILES := src/foo/bar/a.c src/foo/bar/b.c src/foo/bar/c.c
