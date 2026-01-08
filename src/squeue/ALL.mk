INSTALL_BIN += squeue

squeue.TXTFILES := $(call FileList, help.txt usage.txt)

squeue.CFILES := $(call FileList,\
	squeue.c \
	print.c \
	opts.c \
	sort.c \
)

squeue.CFILES_EXTRA = $(slurmfull.CFILES)
