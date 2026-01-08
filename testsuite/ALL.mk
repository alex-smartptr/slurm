_subdirs := expect slurm_unit performance

-include $(foreach D,$(_subdirs),$(Here)/$(D)/ALL.mk)
