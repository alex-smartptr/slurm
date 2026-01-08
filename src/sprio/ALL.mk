INSTALL_BIN += sprio

sprio.TXTFILES := $(call FileList, help.txt usage.txt)

sprio.CFILES := $(call FileList,\
	sprio.c \
	print.c \
	opts.c \
	sort.c \
	filter.c \
)

sprio.CFILES_EXTRA = $(slurmfull.CFILES)
