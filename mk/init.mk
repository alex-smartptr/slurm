ifndef _init_mk
_init_mk := 1

## -- Make settings --

# Grab the first target "all".
.PHONY: all
all: default

# Eliminate all default rules.
.SUFFIXES:

# Don't leave half-finished targets lying around.
.DELETE_ON_ERROR:

# Turn on secondary expansion
.SECONDEXPANSION:


## -- Make variables --

# Useful constants
EMPTY :=
COMMA := ,
SPACE := $(EMPTY) $(EMPTY)
define NEWLINE


endef

# Default to compiling a debug version. Override with command-line: DEBUG=0
ifeq ($(origin DEBUG), undefined)
  DEBUG := 1
endif

ifeq "$(DEBUG)" "1"
  __debug := -debug
endif

ifneq (,$(filter s,$(MAKEFLAGS)))
  SILENT := 1
else
  SILENT := 0
endif


## -- Build Directories --

# Root directory of whole build.
ROOTDIR := $(PWD)

BUILDDIR := $(BUILDDIR:%/=%)$(FLAVOUR:%=-%)$(__debug)

# Root for all (static) object files.
OBJDIR  := $(BUILDDIR)/OBJ

# Root for all (PIC) object files.
POBDIR  := $(BUILDDIR)/POB

# Binaries
BINDIR  := $(BUILDDIR)/bin

# Libraries
LIBDIR  := $(BUILDDIR)/lib

# Plugins
PLUGINDIR := $(LIBDIR)/slurm

# Test results go here.
TESTDIR := $(BUILDDIR)/test.dir

# Generated HTML
HTMLDIR := $(BUILDDIR)/html


## -- Build variables --

# CPP include paths.
CPPINCLUDES += .

# Extra files to remove during clean
CLEANFILES :=

  
## Targets

# User files set these variables to drive the build.
#
# EXE             - Executables: foo => build/bin/foo
# LIB             - Static libraries: foo => build/lib/libfoo.a
# SOLIB           - Shared libraries: foo => build/lib/libfoo.so
# PLUGIN          - Plugins: foo => build/lib/slurm/foo.so
# INSTALL_BIN     - Binaries to install
# INSTALL_SBIN    - "
# INSTALL_HEADERS - Headers to install
# TEST            - Test executables
# DUMMY           - No target, just a grouping. Allows foo.CFLAGS := -foo


endif # _init_mk
