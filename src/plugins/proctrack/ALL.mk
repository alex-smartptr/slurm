# Makefile for proctrack plugins

## proctrack_linuxproc

PLUGIN += proctrack_linuxproc
proctrack_linuxproc.CFILES := $(call FileList, linuxproc/, \
	proctrack_linuxproc.c \
	kill_tree.c \
)


## proctrack_pgid

PLUGIN += proctrack_pgid
proctrack_pgid.CFILES := $(Here)/pgid/proctrack_pgid.c


## proctrack_cgroup

ifdef WITH_CGROUP
PLUGIN += proctrack_cgroup
proctrack_cgroup.CFILES := $(Here)/cgroup/proctrack_cgroup.c
endif
