## FLAVOUR=pgo (Profile-Guided Optimisation)

# Set PROFILE_DIR variable to set location to which profiles are written.
# See: https://gcc.gnu.org/onlinedocs/gcc/Instrumentation-Options.html#index-fprofile-generate

# By default, place profiles in directory /tmp/pgo-<PID>
ifeq ($(origin PROFILE_DIR), undefined)
  PROFILE_DIR := /tmp/pgo-%p
endif

CFLAGS += -fprofile-generate=$(PROFILE_DIR)

# Do not use flag -fprofile-use=
override USE_PROFILE :=

# Take everything else from the default GCC flavour.
include mk/gcc.mk
