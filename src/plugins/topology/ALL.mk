# Makefile for topology plugins

## Common

topology_common.CFILES := $(call FileList, common/, \
	common_topo.c \
	eval_nodes.c \
	gres_filter.c \
	gres_sched.c \
)


## topology_block

PLUGIN += topology_block
topology_block.CFILES := $(call FileList, block/, \
	topology_block.c \
	block_record.c \
	eval_nodes_block.c \
)
topology_block.CFILES_EXTRA = $(topology_common.CFILES)


## topology_flat

PLUGIN += topology_flat
topology_flat.CFILES := $(Here)/flat/topology_flat.c
topology_flat.CFILES_EXTRA = $(topology_common.CFILES)


## topology_tree

PLUGIN += topology_tree
topology_tree.CFILES := $(call FileList, tree/, \
	topology_tree.c \
	switch_record.c \
	eval_nodes_tree.c \
)
topology_tree.CFILES_EXTRA = $(topology_common.CFILES)
