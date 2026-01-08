# Makefile for prep plugins

## prep_script

PLUGIN += prep_script
prep_script.CFILES := $(call FileList, script/, \
	prep_script.c \
	prep_script_slurmctld.c \
	prep_script_slurmd.c \
)
