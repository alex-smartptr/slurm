INSTALL_BIN += sshare

sshare.CFILES := $(call FileList,\
	process.c \
	sshare.c \
)

sshare.CFILES_EXTRA = $(slurmfull.CFILES)
sshare.LDLIBS := $(READLINE_LIBS)
