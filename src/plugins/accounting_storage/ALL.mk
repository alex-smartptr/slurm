## Common

accounting_storage_common.CFILES := $(Here)/common/common_as.c


## accounting_storage_ctld_relay

PLUGIN += accounting_storage_ctld_relay
accounting_storage_ctld_relay.CFILES := $(call FileList, ctld_relay/, \
	accounting_storage_ctld_relay.c \
)
accounting_storage_ctld_relay.CFILES_EXTRA = $(accounting_storage_common.CFILES)


## accounting_storage_slurmdbd

PLUGIN += accounting_storage_slurmdbd
accounting_storage_slurmdbd.CFILES := $(call FileList, slurmdbd/, \
	accounting_storage_slurmdbd.c \
	as_ext_dbd.c \
	dbd_conn.c \
	slurmdbd_agent.c \
)
accounting_storage_slurmdbd.CFILES_EXTRA = $(accounting_storage_common.CFILES)


## accounting_storage_mysql

ifdef WITH_MYSQL
PLUGIN += accounting_storage_mysql
accounting_storage_mysql.CFILES := $(call FileList, mysql/, \
	accounting_storage_mysql.c \
	as_mysql_acct.c \
	as_mysql_tres.c \
	as_mysql_archive.c \
	as_mysql_assoc.c \
	as_mysql_cluster.c \
	as_mysql_convert.c \
	as_mysql_federation.c \
	as_mysql_fix_runaway_jobs.c \
	as_mysql_job.c \
	as_mysql_jobacct_process.c \
	as_mysql_problems.c \
	as_mysql_qos.c \
	as_mysql_resource.c \
	as_mysql_resv.c \
	as_mysql_rollup.c \
	as_mysql_txn.c \
	as_mysql_usage.c \
	as_mysql_user.c \
	as_mysql_wckey.c \
)
accounting_storage_mysql.CFILES_EXTRA = \
	$(accounting_storage_common.CFILES) \
	$(database.CFILES)
# Compile MySQL files with extra flags
accounting_storage_mysql.CFLAGS := $(MYSQL_CFLAGS)
accounting_storage_mysql.LIBS := mysqlclient
endif
