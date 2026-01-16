## FLAVOUR=pgo (Profile-Guided Optimisation)

# Set PROFILE_DIR variable to set location to which profiles are written.
# See: https://gcc.gnu.org/onlinedocs/gcc/Instrumentation-Options.html#index-fprofile-generate

ifeq "$(DEBUG)" "1"
  $(error PGO is only compatible with non-debug builds. Set DEBUG=0.)
endif

# By default, place profiles in directory /tmp/pgo-<PID>
ifeq ($(origin PROFILE_DIR), undefined)
  PROFILE_DIR := /tmp/pgo-%p
endif

CFLAGS += -fprofile-generate=$(PROFILE_DIR)

# Do not use flag -fprofile-use=
override USE_PROFILE :=

# Take everything else from the default GCC flavour.
include mk/gcc.mk

# ...but remove LTO, as it might cause problems with profiling builds.
CFLAGS.NDEBUG := $(filter-out -flto%,$(CFLAGS.NDEBUG))
