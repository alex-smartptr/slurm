INSTALL_BIN += scrontab

scrontab.TXTFILES := $(call FileList,\
	default_crontab.txt \
	usage.txt \
)

scrontab.CFILES := $(call FileList,\
	env.c \
	opt.c \
	parse.c \
	scrontab.c \
)

scrontab.CFILES_EXTRA = $(slurmfull.CFILES)
