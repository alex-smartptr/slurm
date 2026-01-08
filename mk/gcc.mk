## GCC specific modifications.

# Other flavours can replace this with their own.

# General set-up
CFLAGS  += -Wall
LDFLAGS += -rdynamic

# Debug
CFLAGS.DEBUG += -g -Og

# Release
CPPDEFINES.NDEBUG += NDEBUG
CFLAGS.NDEBUG += -O3 -flto=auto

# Setting the variable USE_PROFILE triggers profile-guided optimisation
ifneq "$(USE_PROFILE)" ""
 ifeq "$(wildcard $(USE_PROFILE)/*)" ""
  $(error You specified USE_PROFILE=$(USE_PROFILE), but that directory is empty.)
 endif
 ifeq "$(DEBUG)" "1"
  $(info USE_PROFILE is ignored by debug builds. Set DEBUG=0 too?)
 endif
 CFLAGS.NDEBUG += -fprofile-use=$(USE_PROFILE)
endif

# GNU ar does not require a separate call to ranlib
ARFLAGS := rcs
