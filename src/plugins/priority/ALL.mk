## priority_basic

PLUGIN += priority_basic
priority_basic.CFILES := $(Here)/basic/priority_basic.c


## priority_multifactor

PLUGIN += priority_multifactor
priority_multifactor.CFILES := $(call FileList, multifactor/, \
	priority_multifactor.c \
	fair_tree.c \
)
