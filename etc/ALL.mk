# Rules for customising, and installing various (example) config files.

_etc_infiles = $(call FileList, \
	init.d.slurmdbd.in \
	init.d.slurm.in \
	sackd.service.in \
	slurmctld.service.in \
	slurmdbd.service.in \
	slurmd.service.in \
	slurmrestd.service.in \
	slurm.pc.in \
)

_etc_vars := \
  bindir \
  includedir \
  libdir \
  sbindir \
  sysconfdir \
  sharedstatedir \
  SLURM_VERSION_STRING \
  SLURMRESTD_PORT \
  SYSTEMD_TASKSMAX_OPTION \

_sedsub = -e 's|@$(1)[@]|$($(1))|g'
_edit := $(SED) $(foreach V,$(_etc_vars),$(call _sedsub,$(V)))

_etc_outfiles := $(patsubst $(Here)/%.in, $(ETCDIR)/%, $(_etc_infiles))

.PHONY: etc
etc: $(_etc_outfiles)
default: etc
$(_etc_outfiles): $(ETCDIR)/%: $(Here)/%.in $(Here)/ALL.mk | $(ETCDIR)
	@echo "SED    > $@"
	$(_edit) $< > $@


## install / uninstall

ifdef WITH_PKG_CONFIG
  $(call InstallFileRule, $(ETCDIR)/slurm.pc, $(DESTDIR)$(pkgconfigdir)/slurm.pc)
endif

ifdef WITH_SYSTEMD_UNITS
  $(if $(systemdsystemunitdir),,$(error `systemdsystemunitdir` not set!))

  _systemd_services := \
    sackd.service \
    slurmctld.service \
    slurmdbd.service \
    slurmd.service \
    $(if $(WITH_SLURMRESTD), slurmrestd.service)

  $(foreach S, $(_systemd_services), $(call InstallFileRule, \
    $(ETCDIR)/$(S), \
    $(DESTDIR)$(systemdsystemunitdir)/$(S) \
  ))
endif
