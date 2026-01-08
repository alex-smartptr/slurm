# Makefile for preemption plugins

## preempt_partition_prio

PLUGIN += preempt_partition_prio
preempt_partition_prio.CFILES := $(Here)/partition_prio/preempt_partition_prio.c


## preempt_qos

PLUGIN += preempt_qos
preempt_qos.CFILES := $(Here)/qos/preempt_qos.c
