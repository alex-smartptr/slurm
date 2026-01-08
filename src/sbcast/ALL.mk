INSTALL_BIN += sbcast

sbcast.CFILES := $(call FileList,\
	opts.c \
	sbcast.c \
)

sbcast.CFILES_EXTRA = \
  $(bcast.CFILES) \
  $(slurmfull.CFILES) \
