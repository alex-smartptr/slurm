# Makefile for accounting gather interconnect plugins

ifdef BUILD_OFED

## ofed

PLUGIN += acct_gather_interconnect_ofed
acct_gather_interconnect_ofed.CFILES   := $(Here)/ofed/acct_gather_interconnect_ofed.c
acct_gather_interconnect_ofed.CPPFLAGS := $(OFED_CPPFLAGS)
acct_gather_interconnect_ofed.LDFLAGS  := $(OFED_LDFLAGS)
acct_gather_interconnect_ofed.LDLIBS   := $(OFED_LIBS)

endif # BUILD_OFED


## sysfs

PLUGIN += acct_gather_interconnect_sysfs
acct_gather_interconnect_sysfs.CFILES := $(Here)/sysfs/acct_gather_interconnect_sysfs.c
