# Makefile for cli_filter plugins

## Common

cli_filter_common.CFILES := $(Here)/common/cli_filter_common.c


## cli_filter_lua

ifdef HAVE_LUA
PLUGIN += cli_filter_lua
cli_filter_lua.CFILES       := $(Here)/lua/cli_filter_lua.c
cli_filter_lua.CFILES_EXTRA  = $(cli_filter_common.CFILES) $(slurm_lua.CFILES)
cli_filter_lua.CPPFLAGS     := $(lua_CFLAGS)
cli_filter_lua.LDLIBS       := $(lua_LIBS)
endif


## cli_filter_syslog

PLUGIN += cli_filter_syslog
cli_filter_syslog.CFILES := $(Here)/syslog/cli_filter_syslog.c
cli_filter_syslog.CFILES_EXTRA = $(cli_filter_common.CFILES)


## cli_filter_user_defaults

PLUGIN += cli_filter_user_defaults
cli_filter_user_defaults.CFILES := $(Here)/user_defaults/cli_filter_user_defaults.c
cli_filter_user_defaults.CFILES_EXTRA = $(cli_filter_common.CFILES)
