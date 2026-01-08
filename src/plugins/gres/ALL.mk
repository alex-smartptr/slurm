# Makefile for gres plugins

## Common

gres_common.CFILES := $(call FileList, common/, \
	gres_common.c \
	gres_c_s.c \
)


## gres_gpu

PLUGIN += gres_gpu
gres_gpu.CFILES      := $(Here)/gpu/gres_gpu.c
gres_gpu.CFILES_EXTRA = $(gres_common.CFILES)


## gres_nic

PLUGIN += gres_nic
gres_nic.CFILES      := $(Here)/nic/gres_nic.c
gres_nic.CFILES_EXTRA = $(gres_common.CFILES)


## gres_mps

PLUGIN += gres_mps
gres_mps.CFILES      := $(Here)/mps/gres_mps.c
gres_mps.CFILES_EXTRA = $(gres_common.CFILES)
gres_mps.CPPFLAGS    := $(NVML_CPPFLAGS)


## gres_shard

PLUGIN += gres_shard
gres_shard.CFILES      := $(Here)/shard/gres_shard.c
gres_shard.CFILES_EXTRA = $(gres_common.CFILES)
