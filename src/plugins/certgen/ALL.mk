PLUGIN += certgen_script

certgen_script.CFILES := $(call FileList, script/, \
	certgen_script.c \
)
certgen_script.TXTFILES := $(call FileList, script/, \
	certgen.sh.txt \
	keygen.sh.txt \
)
