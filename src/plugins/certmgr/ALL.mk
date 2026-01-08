PLUGIN += certmgr_script

certmgr_script.CFILES := $(call FileList, script/, \
	certmgr_script.c \
)
