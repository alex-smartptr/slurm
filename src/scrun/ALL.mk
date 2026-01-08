ifdef LINUX_BUILD
ifdef HAVE_LUA

INSTALL_BIN += scrun

scrun.TXTFILES := $(Here)/usage.txt

scrun.CFILES := $(call FileList,\
	alloc.c \
	anchor.c \
	commands.c \
	lua.c \
	rpc.c \
	scrun.c \
	srun.c \
	spank.c \
	state.c \
)

scrun.CFILES_EXTRA = \
  $(slurmfull.CFILES) \
  $(slurm_lua.CFILES) \

scrun.CFLAGS := $(lua_CFLAGS)
scrun.LDLIBS := $(lua_LIBS)

endif # HAVE_LUA
endif # LINUX_BUILD
