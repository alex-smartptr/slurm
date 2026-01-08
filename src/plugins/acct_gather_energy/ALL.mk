## gpu

PLUGIN += acct_gather_energy_gpu
acct_gather_energy_gpu.CFILES := $(call FileList, gpu/, \
	acct_gather_energy_gpu.c \
)


## ibmaem

PLUGIN += acct_gather_energy_ibmaem
acct_gather_energy_ibmaem.CFILES := $(call FileList, ibmaem/, \
	acct_gather_energy_ibmaem.c \
)


## pm_counters

PLUGIN += acct_gather_energy_pm_counters
acct_gather_energy_pm_counters.CFILES := $(call FileList, pm_counters/, \
	acct_gather_energy_pm_counters.c \
)


## rapl

PLUGIN += acct_gather_energy_rapl
acct_gather_energy_rapl.CFILES := $(call FileList, rapl/, \
	acct_gather_energy_rapl.c \
)


ifdef BUILD_IPMI

## ipmi

PLUGIN += acct_gather_energy_ipmi
acct_gather_energy_ipmi.CFILES := $(call FileList, ipmi/, \
	acct_gather_energy_ipmi.c \
	acct_gather_energy_ipmi_config.c \
)
acct_gather_energy_ipmi.CPPFLAGS := $(FREEIPMI_CPPFLAGS)
acct_gather_energy_ipmi.LDFLAGS  := $(FREEIPMI_LDFLAGS)
acct_gather_energy_ipmi.LDLIBS   := $(FREEIPMI_LIBS)


## xcc

PLUGIN += acct_gather_energy_xcc
acct_gather_energy_xcc.CFILES := $(call FileList, xcc/, \
	acct_gather_energy_xcc.c \
)
acct_gather_energy_xcc.CPPFLAGS := $(FREEIPMI_CPPFLAGS)
acct_gather_energy_xcc.LDFLAGS  := $(FREEIPMI_LDFLAGS)
acct_gather_energy_xcc.LDLIBS   := $(FREEIPMI_LIBS)

endif # BUILD_IPMI
