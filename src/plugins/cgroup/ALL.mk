# Makefile for cgroup plugins

## Common

cgroup_common.CFILES := $(Here)/common/cgroup_common.c


## cgroup_v1

PLUGIN += cgroup_v1
cgroup_v1.CFILES := $(call FileList, v1/, \
	cgroup_v1.c \
	xcgroup.c \
)
cgroup_v1.CFILES_EXTRA = $(cgroup_common.CFILES)


## cgroup_v2

ifdef WITH_BPF
ifdef WITH_DBUS

PLUGIN += cgroup_v2
cgroup_v2.CFILES := $(call FileList, v2/, \
	cgroup_v2.c \
	cgroup_dbus.c \
	ebpf.c \
)
cgroup_v2.CFILES_EXTRA = $(cgroup_common.CFILES)
cgroup_v2.CPPFLAGS := $(dbus_CFLAGS)
cgroup_v2.LDLIBS := $(dbus_LIBS)

endif
endif
