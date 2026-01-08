INSTALL_SBIN += slurmdbd

slurmdbd.CFILES := $(call FileList,\
	backup.c \
	proc_req.c \
	read_config.c \
	rpc_mgr.c \
	slurmdbd.c \
)

slurmdbd.CFILES_EXTRA = $(slurmfull.CFILES)
