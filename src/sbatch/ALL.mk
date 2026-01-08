INSTALL_BIN += sbatch

sbatch.CFILES := $(call FileList,\
	opt.c \
	sbatch.c \
	xlate.c \
)

sbatch.CFILES_EXTRA = $(slurmfull.CFILES)
