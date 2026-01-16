# Variables that may be set

# BUILDDIR    -  Root for all build files. Usually empty, which puts the build
#                into the current dir. May be set to another volume (/tmp for
#                example).
# CPPFLAGS
# CPPINCLUDES - list of CPP include paths, e.g. path/one /abs/path/two
# CPPDEFINES  - list of defines, e.g. VAR1 VAR2=VAL VAR3
# CFLAGS
# FLAVOUR     - architecture-specific build file $(FLAVOUR).mk
# LDFLAGS     - non-library linker flags
# LDLIBS      - library linker flags (-L<path> -l<lib>)
# LIBPATHS    - library paths (<path> => -L<path>)
# LIBS        - libraries (<lib> => -l<lib>)
# LINK_STATIC - 1: Executables are statically linked.
# DEBUG       - 0: Optimize

# These component makefiles are all in the same directory as this file.
include mk/init.mk
include mk/utilities.mk
include mk/templates.mk
include mk/functions.mk

__flavour_mk := $(wildcard mk/$(FLAVOUR).mk)
ifneq "$(__flavour_mk)" ""
  include $(__flavour_mk)
else
  include mk/gcc.mk
endif

# .DEBUG or .NDEBUG hooks allow user rules to customise the build
# for debug/no-debug cases.
# ! NOTE: Some files are always built as DEBUG=1, so it's important that
# ! all of these variables remain late-bound (set using =, not :=).
__debug_switch = $(if $(DEBUG:0=),DEBUG,NDEBUG)
CPPDEFINES  += $(CPPDEFINES.$(__debug_switch))
CPPFLAGS    += $(CPPFLAGS.$(__debug_switch))
CPPINCLUDES += $(CPPINCLUDES.$(__debug_switch))
CFLAGS      += $(CFLAGS.$(__debug_switch))
LIBPATHS    += $(LIBPATHS.$(__debug_switch))
LIBS        += $(LIBS.$(__debug_switch))
LDFLAGS     += $(LDFLAGS.$(__debug_switch))
LDLIBS      += $(LDLIBS.$(__debug_switch))
