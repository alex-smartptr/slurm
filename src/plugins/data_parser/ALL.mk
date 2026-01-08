# Function to generate file list.
_files := \
	api.c \
	slurmdb_helpers.c \
	events.c \
	alloc.c \
	openapi.c \
	parsing.c \
	parsers.c \


## data_parser_v0_0_42

PLUGIN += data_parser_v0_0_42
data_parser_v0_0_42.CFILES := $(call FileList, v0.0.42/, $(_files))
data_parser_v0_0_42.CPPDEFINES += \
  DATA_VERSION=v0.0.42 \
  PLUGIN_ID=12004 \
  PLUGIN_RELEASED=SLURM_24_11_PROTOCOL_VERSION \


## data_parser_v0_0_43 (?? PLUGIN_ID is wrong?)

PLUGIN += data_parser_v0_0_43
data_parser_v0_0_43.CFILES := $(call FileList, v0.0.43/, $(_files))
data_parser_v0_0_43.CPPDEFINES += \
  DATA_VERSION=v0.0.43 \
  PLUGIN_ID=12004 \
  PLUGIN_RELEASED=SLURM_25_05_PROTOCOL_VERSION \


## data_parser_v0_0_44

PLUGIN += data_parser_v0_0_44
data_parser_v0_0_44.CFILES := $(call FileList, v0.0.44/, $(_files))
data_parser_v0_0_44.CPPDEFINES += \
  DATA_VERSION=v0.0.44 \
  PLUGIN_ID=12005 \
  PLUGIN_RELEASED=SLURM_25_11_PROTOCOL_VERSION \


## data_parser_v0_0_45

PLUGIN += data_parser_v0_0_45
data_parser_v0_0_45.CFILES := $(call FileList, v0.0.45/, $(_files))
data_parser_v0_0_45.CPPDEFINES += \
  DATA_VERSION=v0.0.45 \
  PLUGIN_ID=12006 \
  PLUGIN_RELEASED=SLURM_26_05_PROTOCOL_VERSION \
