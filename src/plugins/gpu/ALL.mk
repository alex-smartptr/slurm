# Makefile for gpu plugins

## Common

gpu_common.CFILES := $(Here)/common/gpu_common.c


## gpu_generic (DOES NOT USE COMMON CODE)

PLUGIN += gpu_generic
gpu_generic.CFILES := $(Here)/generic/gpu_generic.c


## gpu_nrt ??NOT PREVIOUSLY LINKED WITH COMMON, BUT ACTUALLY SEEMS TO USE IT??

PLUGIN += gpu_nrt
gpu_nrt.CFILES      := $(Here)/nrt/gpu_nrt.c
gpu_nrt.CFILES_EXTRA = $(gpu_common.CFILES)


## gpu_nvidia

PLUGIN += gpu_nvidia
gpu_nvidia.CFILES      := $(Here)/nvidia/gpu_nvidia.c
gpu_nvidia.CFILES_EXTRA = $(gpu_common.CFILES)


## gpu_rsmi

ifdef BUILD_RSMI
PLUGIN += gpu_rsmi
gpu_rsmi.CFILES      := $(Here)/rsmi/gpu_rsmi.c
gpu_rsmi.CFILES_EXTRA = $(gpu_common.CFILES)
gpu_rsmi.CPPFLAGS    := $(RSMI_CPPFLAGS)
gpu_rsmi.LDLIBS      := $(NUMA_LIBS)
endif


## gpu_nvml

ifdef BUILD_NVML
PLUGIN += gpu_nvml
gpu_nvml.CFILES      := $(Here)/nvml/gpu_nvml.c
gpu_nvml.CFILES_EXTRA = $(gpu_common.CFILES)
gpu_nvml.CPPFLAGS    := $(NVML_CPPFLAGS)
endif


## gpu_oneapi

ifdef BUILD_ONEAPI
PLUGIN += gpu_oneapi
gpu_oneapi.CFILES      := $(Here)/oneapi/gpu_oneapi.c
gpu_oneapi.CFILES_EXTRA = $(gpu_common.CFILES)
gpu_oneapi.CPPFLAGS    := $(ONEAPI_CPPFLAGS)
endif
