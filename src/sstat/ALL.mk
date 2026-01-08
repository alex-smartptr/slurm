INSTALL_BIN += sstat

sstat.CFILES := $(call FileList,\
	options.c \
	print.c \
	sstat.c \
)

sstat.CFILES_EXTRA = $(slurmfull.CFILES)
