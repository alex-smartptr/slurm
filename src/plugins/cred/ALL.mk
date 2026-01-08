# Makefile for cred plugins

## Common

cred_common.CFILES := $(Here)/common/cred_common.c


## cred_none - Null job credential plugin

PLUGIN += cred_none
cred_none.CFILES        := $(Here)/none/cred_none.c
cred_none.CFILES_EXTRA   = $(cred_common.CFILES)


## cred_munge

ifdef WITH_MUNGE
PLUGIN += cred_munge
cred_munge.CFILES       := $(Here)/none/cred_none.c
cred_munge.CFILES_EXTRA  = $(cred_common.CFILES)
cred_munge.CPPFLAGS     := $(MUNGE_CPPFLAGS)
cred_munge.LDFLAGS      := $(MUNGE_LDFLAGS)
endif
