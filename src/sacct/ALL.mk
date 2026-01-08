INSTALL_BIN += sacct

sacct.TXTFILES := $(call FileList,\
	help.txt \
)
sacct.CFILES := $(call FileList,\
	options.c \
	print.c \
	process.c \
	sacct.c \
)

sacct.CFILES_EXTRA = $(slurmfull.CFILES)
