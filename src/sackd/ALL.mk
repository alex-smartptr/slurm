INSTALL_SBIN += sackd

sackd.TXTFILES    := $(Here)/usage.txt
sackd.CFILES      := $(Here)/sackd.c
sackd.CFILES_EXTRA = $(slurmfull.CFILES)
