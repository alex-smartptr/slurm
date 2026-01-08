# Makefile for switch plugins

## switch_nvidia_imex

ifdef LINUX_BUILD
PLUGIN += switch_nvidia_imex
switch_nvidia_imex.CFILES := $(call FileList, nvidia_imex/, \
	imex_device.c \
	switch_nvidia_imex.c \
)
endif


## switch_hpe_slingshot

ifdef WITH_SWITCH_HPE_SLINGSHOT

ifndef WITH_JSON_PARSER
  $(error !! WITH_SWITCH_HPE_SLINGSHOT requires WITH_JSON_PARSER)
else

ifndef WITH_CURL
  $(error !! WITH_SWITCH_HPE_SLINGSHOT requires WITH_CURL)
else

PLUGIN += switch_hpe_slingshot
switch_hpe_slingshot.CFILES := $(call FileList, hpe_slingshot/, \
	apinfo.c \
	collectives.c \
	config.c \
	rest.c \
	setup_nic.c \
	switch_hpe_slingshot.c \
)
switch_hpe_slingshot.CFILES_EXTRA = $(slurm_curl.CFILES)
switch_hpe_slingshot.CPPFLAGS := \
  $(HPE_SLINGSHOT_CFLAGS) $(LIBCURL_CPPFLAGS) $(JSON_CPPFLAGS)
switch_hpe_slingshot.LDLIBS := $(LIBCURL) $(JSON_LDFLAGS)

endif # WITH_CURL
endif # WITH_JSON_PARSER
endif # WITH_SWITCH_HPE_SLINGSHOT
