INSTALL_SBIN += slurmctld

slurmctld.TXTFILES := $(call FileList,\
	usage.txt \
)

slurmctld.CFILES := $(call FileList,\
	acct_policy.c \
	agent.c \
	backup.c \
	controller.c \
	crontab.c \
	fed_mgr.c \
	gang.c \
	groups.c \
	heartbeat.c \
	http.c \
	job_mgr.c \
	job_scheduler.c \
	job_state.c \
	licenses.c \
	locks.c \
	node_mgr.c \
	node_scheduler.c \
	partition_mgr.c \
	ping_nodes.c \
	power_save.c \
	prep_slurmctld.c \
	proc_req.c \
	rate_limit.c \
	read_config.c \
	reservation.c \
	rpc_queue.c \
	sackd_mgr.c \
	slurmscriptd.c \
	slurmscriptd_protocol_defs.c \
	slurmscriptd_protocol_pack.c \
	state_save.c \
	statistics.c \
	trigger_mgr.c \
)

slurmctld.CFILES_EXTRA = \
  $(slurmfull.CFILES) \
  $(stepmgr.CFILES) \
  $(slurmctld_interfaces.CFILES) \
