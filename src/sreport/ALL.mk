INSTALL_BIN += sreport

sreport.CFILES := $(call FileList,\
	sreport.c \
	cluster_reports.c \
	job_reports.c \
	user_reports.c \
	resv_reports.c \
	common.c \
)

sreport.CFILES_EXTRA = $(slurmfull.CFILES)
sreport.LDLIBS := $(READLINE_LIBS)
