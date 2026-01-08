INSTALL_BIN += scontrol

scontrol.TXTFILES := $(Here)/usage.txt

scontrol.CFILES := $(call FileList,\
	common.c \
	create_res.c \
	info_burst_buffer.c \
	info_assoc_mgr.c \
	info_fed.c \
	info_job.c \
	info_lics.c \
	info_node.c \
	info_part.c \
	info_res.c \
	power_node.c \
	reboot_node.c \
	scontrol.c \
	update_job.c \
	update_node.c \
	update_part.c \
	update_step.c \
)

scontrol.CFILES_EXTRA = $(slurmfull.CFILES)
scontrol.LDLIBS := $(READLINE_LIBS)
