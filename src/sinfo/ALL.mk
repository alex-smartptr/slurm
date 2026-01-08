INSTALL_BIN += sinfo

sinfo.TXTFILES := $(call FileList, help.txt usage.txt)

sinfo.CFILES := $(call FileList,\
	opts.c \
	print.c \
	sinfo.c \
	sort.c \
)

sinfo.CFILES_EXTRA = $(slurmfull.CFILES)
