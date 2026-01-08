INSTALL_BIN += sdiag

sdiag.CFILES := $(call FileList, opts.c sdiag.c)

sdiag.CFILES_EXTRA = $(slurmfull.CFILES)
