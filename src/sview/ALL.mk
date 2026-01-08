ifdef BUILD_SVIEW

INSTALL_BIN += sview

sview.CFILES := $(call FileList,\
	admin_info.c \
	bb_info.c \
	common.c \
	config_info.c \
	defaults.c \
	grid.c \
	gthread_helper.c \
	job_info.c \
	node_info.c \
	part_info.c \
	popups.c \
	resv_info.c \
	submit_info.c \
	sview.c \
)

sview.CFILES_EXTRA = $(slurmfull.CFILES)

sview.CPPDEFINES := GTK_DISABLE_DEPRECATED
sview.CFLAGS := $(GTK_CFLAGS)
sview.LDLIBS := $(GTK_LIBS)

endif # BUILD_SVIEW
