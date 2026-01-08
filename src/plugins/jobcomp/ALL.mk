# Makefile for jobcomp plugins

## Common

jobcomp_common.CFILES := $(Here)/common/jobcomp_common.c


## jobcomp_elasticsearch

ifdef WITH_CURL
PLUGIN += jobcomp_elasticsearch
jobcomp_elasticsearch.CFILES := $(Here)/elasticsearch/jobcomp_elasticsearch.c
jobcomp_elasticsearch.CPPFLAGS := $(LIBCURL_CPPFLAGS)
jobcomp_elasticsearch.LDLIBS := $(LIBCURL)
endif


## jobcomp_filetxt

PLUGIN += jobcomp_filetxt
jobcomp_filetxt.CFILES := $(call FileList, filetxt/, \
	jobcomp_filetxt.c \
	filetxt_jobcomp_process.c \
)


## jobcomp_kafka

ifdef WITH_RDKAFKA
PLUGIN += jobcomp_kafka
jobcomp_kafka.CFILES := $(call FileList, kafka/, \
	jobcomp_kafka.c \
	jobcomp_kafka_message.c \
)
jobcomp_kafka.LDFLAGS := $(RDKAFKA_LDFLAGS)
jobcomp_kafka.LDLIBS := $(RDKAFKA_LIBS)
endif


## jobcomp_lua

ifdef HAVE_LUA
PLUGIN += jobcomp_lua
jobcomp_lua.CFILES := $(Here)/lua/jobcomp_lua.c
jobcomp_lua.CFILES_EXTRA = $(slurm_lua.CFILES)
jobcomp_lua.CPPFLAGS := $(lua_CFLAGS)
jobcomp_lua.LDLIBS := $(lua_LIBS)
endif


## jobcomp_script

PLUGIN += jobcomp_script
jobcomp_script.CFILES := $(Here)/script/jobcomp_script.c


## jobcomp_mysql

ifdef WITH_MYSQL
PLUGIN += jobcomp_mysql
jobcomp_mysql.CFILES := $(call FileList, mysql/, \
	jobcomp_mysql.c \
	mysql_jobcomp_process.c \
)
jobcomp_mysql.CFILES_EXTRA := $(database.CFILES)
jobcomp_mysql.CPPFLAGS := $(MYSQL_CFLAGS)
jobcomp_mysql.LDLIBS := $(MYSQL_LIBS)
endif
