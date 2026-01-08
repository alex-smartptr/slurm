# Makefile for scheduler plugins

## sched_backfill

PLUGIN += sched_backfill
sched_backfill.CFILES := $(call FileList, backfill/, \
	backfill_wrapper.c \
	backfill.c \
	oracle.c \
)


## sched_builtin

PLUGIN += sched_builtin
sched_builtin.CFILES := $(call FileList, builtin/, \
	builtin_wrapper.c \
	builtin.c \
)
