## libslurm.so

SOLIB += slurm

slurm.VERSION := $(SLURM_API_CURRENT).$(SLURM_API_AGE).$(SLURM_API_REVISION)


# This file list section is unnecessarily convoluted, but I've done it this
# way to allow comparison with the automake file Makefile.am.

_slurmdbapi_cfiles := $(call FileList,\
	account_functions.c \
	archive_functions.c \
	assoc_functions.c \
	cluster_functions.c \
	cluster_report_functions.c \
	coord_functions.c \
	connection_functions.c \
	extra_get_functions.c \
	federation_functions.c \
	job_functions.c \
	job_report_functions.c \
	qos_functions.c \
	resource_functions.c \
	tres_functions.c \
	usage_functions.c \
	user_functions.c \
	user_report_functions.c \
	wckey_functions.c \
)

_slurmapi_cfiles := $(call FileList,\
	allocate.c \
	allocate_msg.c \
	burst_buffer_info.c \
	assoc_mgr_info.c \
	cancel.c \
	cluster_info.c \
	complete.c \
	config_info.c \
	crontab.c \
	federation_info.c \
	init.c \
	init_msg.c \
	job_info.c \
	job_step_info.c \
	license_info.c \
	node_info.c \
	partition_info.c \
	pmi_server.c \
	reservation_info.c \
	signal.c \
	slurm_get_statistics.c \
	slurm_pmi.c \
	step_io.c \
	step_launch.c \
	submit.c \
	suspend.c \
	token.c \
	topo_info.c \
	triggers.c \
	reconfigure.c \
	update_config.c \
)
_slurmapi_cfiles += $(_slurmdbapi_cfiles)

slurm.CFILES := $(_slurmapi_cfiles)
slurm.CFILES_EXTRA = \
	$(common.CFILES) \
	$(common_interfaces.CFILES) \
	$(conmgr.CFILES)

# Ensure that only certain symbols are exported via libslurm.so
# (The version.map file is fixed, so there's no reason to generate it here,
# it's simpler to just check it into git.)
_slurm_version_map := $(Here)/version.map

_slurm_lib := $(call solib2path, slurm)
$(_slurm_lib): $(_slurm_version_map)

slurm.LDFLAGS := -Wl,--version-script=$(_slurm_version_map)


## Convenience list of source files for including wherever
## libslurmfull.so was previously linked.

slurmfull.CFILES = $(sort \
	$(slurm.CFILES) \
	$(slurm.CFILES_EXTRA) \
)
