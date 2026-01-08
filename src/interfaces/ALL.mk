common_interfaces.CFILES := $(call FileList,\
	accounting_storage.c \
	acct_gather.c \
	acct_gather_energy.c \
	acct_gather_filesystem.c \
	acct_gather_interconnect.c \
	acct_gather_profile.c \
	auth.c \
	certgen.c \
	certmgr.c \
	cgroup.c \
	cli_filter.c \
	conn.c \
	cred.c \
	data_parser.c \
	gpu.c \
	gres.c \
	hash.c \
	http_parser.c \
	jobacct_gather.c \
	jobcomp.c \
	mcs.c \
	metrics.c \
	mpi.c \
	namespace.c \
	node_features.c \
	prep.c \
	priority.c \
	select.c \
	serializer.c \
	site_factor.c \
	switch.c \
	tls.c \
	topology.c \
	url_parser.c \
)

slurmctld_interfaces.CFILES := $(call FileList,\
	burst_buffer.c \
	job_submit.c \
	preempt.c \
	sched_plugin.c \
)

slurmd_interfaces.CFILES := $(call FileList,\
	proctrack.c \
	task.c \
)
