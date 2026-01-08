# Makefile for task plugins

## task_affinity

PLUGIN += task_affinity
task_affinity.CFILES := $(call FileList, affinity/, \
	affinity.c \
	dist_tasks.c \
	numa.c \
	schedutils.c \
	task_affinity.c \
)
task_affinity.LDLIBS := $(NUMA_LIBS)


## task_cgroup

ifdef WITH_CGROUP
PLUGIN += task_cgroup
task_cgroup.CFILES := $(call FileList, cgroup/, \
	task_cgroup.c \
	task_cgroup_cpuset.c \
	task_cgroup_memory.c \
	task_cgroup_devices.c \
)
task_cgroup.CPPFLAGS := $(HWLOC_CPPFLAGS)
endif
