INSTALL_BIN += scancel

scancel.CFILES := $(call FileList,\
	opt.c \
	scancel.c \
)

scancel.CFILES_EXTRA = $(slurmfull.CFILES)
