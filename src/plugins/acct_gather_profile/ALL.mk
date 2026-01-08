# Makefile for accounting gather profile plugins

ifdef BUILD_HDF5

DUMMY += acct_gather_profile_hdf5_api
acct_gather_profile_hdf5_api.CFILES := $(Here)/hdf5/hdf5_api.c
acct_gather_profile_hdf5_api.CPPFLAGS := $(HDF5_CPPFLAGS)


## hdf5 - cpu/core energy accounting plugin.

PLUGIN += acct_gather_profile_hdf5
acct_gather_profile_hdf5.CFILES := $(Here)/hdf5/acct_gather_profile_hdf5.c
acct_gather_profile_hdf5.CFILES_EXTRA = $(acct_gather_profile_hdf5_api.CFILES)
acct_gather_profile_hdf5.CPPFLAGS    := $(HDF5_CPPFLAGS)
acct_gather_profile_hdf5.LDFLAGS     := $(HDF5_LDFLAGS)
acct_gather_profile_hdf5.LDLIBS      := $(HDF5_LIBS)


## hdf5/sh5util

INSTALL_BIN += sh5util
sh5util.CFILES := $(Here)/hdf5/sh5util/sh5util.c
sh5util.CFILES_EXTRA = $(acct_gather_profile_hdf5_api.CFILES)
sh5util.CPPFLAGS    := $(HDF5_CPPFLAGS)
sh5util.LDFLAGS     := $(HDF5_LDFLAGS)
sh5util.LDLIBS      := $(HDF5_LIBS)

endif # BUILD_HDF5


## influxdb

ifdef WITH_CURL
PLUGIN += acct_gather_profile_influxdb
acct_gather_profile_influxdb.CFILES := \
  $(Here)/influxdb/acct_gather_profile_influxdb.c
acct_gather_profile_influxdb.CFILES_EXTRA = $(curl.CFILES)
acct_gather_profile_influxdb.CPPFLAGS    := $(LIBCURL_CPPFLAGS)
acct_gather_profile_influxdb.LDLIBS      := $(LIBCURL)
endif
