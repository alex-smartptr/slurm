# Makefile for job_submit plugins


## job_submit_all_partitions

PLUGIN += job_submit_all_partitions
job_submit_all_partitions.CFILES := \
  $(Here)/all_partitions/job_submit_all_partitions.c


## job_submit_defaults

PLUGIN += job_submit_defaults
job_submit_defaults.CFILES := $(Here)/defaults/job_submit_defaults.c


## job_submit_logging

PLUGIN += job_submit_logging
job_submit_logging.CFILES := $(Here)/logging/job_submit_logging.c


## job_submit_lua

ifdef HAVE_LUA
PLUGIN += job_submit_lua
job_submit_lua.CFILES := $(Here)/lua/job_submit_lua.c
job_submit_lua.CFILES_EXTRA = $(slurm_lua.CFILES)
job_submit_lua.CPPFLAGS := $(lua_CFLAGS)
job_submit_lua.LDLIBS := $(lua_LIBS)
endif


## job_submit_partition

PLUGIN += job_submit_partition
job_submit_partition.CFILES := $(Here)/partition/job_submit_partition.c


## spank_pbs - SPANK PBS plugin

PLUGIN += spank_pbs
spank_pbs.CFILES := $(Here)/pbs/spank_pbs.c


## job_submit_pbs - Job submit PBS plugin

PLUGIN += job_submit_pbs
job_submit_pbs.CFILES := $(Here)/pbs/job_submit_pbs.c
# ?? Original links in spank_pbs plugin, which doesn't seem to be used, and
# ?? triggers multiple symbol definition errors.
#job_submit_pbs.CFILES_EXTRA = $(spank_pbs.CFILES)


## job_submit_require_timelimit

PLUGIN += job_submit_require_timelimit
job_submit_require_timelimit.CFILES := \
  $(Here)/require_timelimit/job_submit_require_timelimit.c


## job_submit_throttle

PLUGIN += job_submit_throttle
job_submit_throttle.CFILES := $(Here)/throttle/job_submit_throttle.c
