# Makefile for auth plugins

## none

PLUGIN += auth_none
auth_none.CFILES := $(Here)/none/auth_none.c


## munge

ifdef WITH_MUNGE
  PLUGIN += auth_munge
  auth_munge.CFILES   := $(Here)/munge/auth_munge.c
  auth_munge.CPPFLAGS := $(MUNGE_CPPFLAGS)
  auth_munge.LDFLAGS  := $(MUNGE_LDFLAGS)
  auth_munge.LDLIBS   := $(MUNGE_LIBS)
endif


ifdef WITH_JWT

  ## jwt

  PLUGIN += auth_jwt
  auth_jwt.CFILES   := $(Here)/jwt/auth_jwt.c
  auth_jwt.CPPFLAGS := $(JWT_CPPFLAGS)
  auth_jwt.LDFLAGS  := $(JWT_LDFLAGS)
  auth_jwt.LDLIBS   := $(JWT_LIBS)


  ## slurm

  PLUGIN += auth_slurm
  auth_slurm.CFILES := $(call FileList, slurm/, \
	auth_slurm.c \
	cred_slurm.c \
	external.c \
	internal.c \
	net_aliases.c \
	sack.c \
	sbcast.c \
	util.c \
  )
  auth_slurm.CFILES_EXTRA = $(cred_common.CFILES)
  auth_slurm.CPPFLAGS    := $(JWT_CPPFLAGS)
  auth_slurm.LDFLAGS     := $(JWT_LDFLAGS)
  auth_slurm.LDLIBS      := $(JWT_LIBS)

endif # WITH_JWT
