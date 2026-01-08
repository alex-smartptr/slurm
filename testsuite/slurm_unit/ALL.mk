_subdirs := backfill common topology

include $(foreach D,$(_subdirs),$(Here)/$(D)/ALL.mk)
