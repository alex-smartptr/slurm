INSTALL_BIN += sacctmgr

sacctmgr.TXTFILES := $(call FileList,\
	usage.txt \
)
sacctmgr.CFILES := $(call FileList,\
	account_functions.c \
	archive_functions.c \
	association_functions.c \
	config_functions.c \
	cluster_functions.c \
	common.c \
	event_functions.c \
	federation_functions.c \
	file_functions.c \
	instance_functions.c \
	runaway_job_functions.c \
	job_functions.c \
	reservation_functions.c \
	resource_functions.c \
	sacctmgr.c \
	qos_functions.c \
	txn_functions.c \
	user_functions.c \
	wckey_functions.c \
	problem_functions.c \
	tres_function.c \
)

sacctmgr.CFILES_EXTRA = $(slurmfull.CFILES)

sacctmgr.LDLIBS := $(READLINE_LIBS)
