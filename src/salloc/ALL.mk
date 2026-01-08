INSTALL_BIN += salloc

salloc.CFILES := $(call FileList,\
	opt.c \
	salloc.c \
)

salloc.CFILES_EXTRA = $(slurmfull.CFILES)
