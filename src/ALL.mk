# bcast
bcast.CFILES := $(Here)/bcast/file_bcast.c

# curl
ifdef WITH_CURL
DUMMY += curl
curl.CFILES := $(Here)/curl/slurm_curl.c
curl.CPPFLAGS := $(LIBCURL_CPPFLAGS)
endif

# database
ifdef WITH_MYSQL
DUMMY += database
database.CFILES := $(Here)/database/mysql_common.c
database.CFLAGS += $(MYSQL_CFLAGS)
database.LDLIBS += $(MYSQL_LIBS) # ?? HAS NO EFFECT
endif

# lua
ifdef HAVE_LUA
DUMMY += slurm_lua
slurm_lua.CFILES := $(Here)/lua/slurm_lua.c
slurm_lua.CPPFLAGS := $(lua_CFLAGS)
endif

_subdirs := \
  api \
  common \
  conmgr \
  interfaces \
  plugins \
  sacct \
  sacctmgr \
  sackd \
  salloc \
  sattach \
  sbatch \
  sbcast \
  scancel \
  scontrol \
  scrontab \
  scrun \
  sdiag \
  sinfo \
  slurmctld \
  slurmd \
  slurmdbd \
  slurmrestd \
  sprio \
  squeue \
  sreport \
  srun \
  sshare \
  sstat \
  strigger \
  stepmgr \
  sview \

# Includes must come LAST, otherwise $(Here) and $(call FileList,...)
# will not function correctly.
include $(foreach D,$(_subdirs),$(Here)/$(D)/ALL.mk)
