INSTALL_BIN += strigger

strigger.CFILES := $(call FileList,\
	opts.c \
	strigger.c \
)

strigger.CFILES_EXTRA = $(slurmfull.CFILES)
