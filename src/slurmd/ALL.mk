DUMMY += slurmd_common
slurmd_common.CFILES := $(call FileList, common/, \
	fname.c \
	privileges.c \
	set_oomadj.c \
	slurmd_cgroup.c \
	slurmd_common.c \
	slurmstepd_init.c \
	xcpuinfo.c \
)

slurmd_common.CPPFLAGS := $(HWLOC_CPPFLAGS)


# slurmd

INSTALL_SBIN += slurmd

slurmd.TXTFILES := $(Here)/slurmd/usage.txt

slurmd.CFILES := $(call FileList, slurmd/, \
	cred_context.c \
	get_mach_stat.c \
	http.c \
	job_mem_limit.c \
	launch_state.c \
	req.c \
	slurmd.c \
)

slurmd.CFILES_EXTRA = \
  $(bcast.CFILES) \
  $(slurmd_common.CFILES) \
  $(slurmd_interfaces.CFILES) \
  $(slurmfull.CFILES) \

slurmd.CPPFLAGS := $(HWLOC_CPPFLAGS)
slurmd.LDFLAGS := $(HWLOC_LDFLAGS)
slurmd.LDLIBS := $(HWLOC_LIBS) $(PAM_LIBS) $(UTIL_LIBS) $(NUMA_LIBS)


# slurmstepd

INSTALL_SBIN += slurmstepd

slurmstepd.CFILES := $(call FileList, slurmstepd/, \
	container.c \
	slurmstepd.c \
	mgr.c \
	task.c \
	slurmstepd_job.c \
	io.c \
	ulimits.c \
	pdebug.c \
	pam_ses.c \
	req.c \
	multi_prog.c \
	step_terminate_monitor.c \
	x11_forwarding.c \
)

slurmstepd.CFILES_EXTRA = \
  $(stepmgr.CFILES) \
  $(slurmd_common.CFILES) \
  $(slurmd_interfaces.CFILES) \
  $(slurmfull.CFILES) \

slurmstepd.CPPFLAGS := $(HWLOC_CPPFLAGS)
slurmstepd.LDFLAGS := $(HWLOC_LDFLAGS)
slurmstepd.LDLIBS := $(HWLOC_LIBS) $(PAM_LIBS) $(UTIL_LIBS) $(libselinux_LIBS)
