# Makefile for jobacct plugins

## Common

jobacct_gather_common.CFILES := $(Here)/common/common_jag.c


## jobacct_gather_linux

PLUGIN += jobacct_gather_linux
jobacct_gather_linux.CFILES := $(Here)/linux/jobacct_gather_linux.c
jobacct_gather_linux.CFILES_EXTRA = $(jobacct_gather_common.CFILES)


## jobacct_gather_cgroup

ifdef WITH_CGROUP
PLUGIN += jobacct_gather_cgroup
jobacct_gather_cgroup.CFILES := $(Here)/cgroup/jobacct_gather_cgroup.c
jobacct_gather_cgroup.CFILES_EXTRA = $(gpu_common.CFILES)
jobacct_gather_cgroup.CPPFLAGS := $(HWLOC_CPPFLAGS)
endif

