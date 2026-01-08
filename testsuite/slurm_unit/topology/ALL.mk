## topology-test

TEST += topology-test
topology-test.CFILES := $(Here)/topology-test.c
topology-test.CFILES_EXTRA = $(slurmfull.CFILES)
topology-test.LDLIBS := $(CHECK_LIBS)

# Customise the slurm.conf for this environment.

_objdir        := $(OBJDIR)/$(Here)
_slurm_conf    := $(_objdir)/slurm.conf
_topology_conf := $(_objdir)/topology.conf
topology-test: $(_slurm_conf) $(_topology_conf)
$(_slurm_conf): $(Here)/slurm.conf
	@echo "SED    > $@"
	$(SED) 's%PluginDir=.*$$%PluginDir=$(PLUGINDIR)%g' $< > $@
$(_topology_conf): $(Here)/topology.conf
	@echo "COPY   > $@"
	$(INSTALL) $< $@
topology-test.ENVIRON := srcdir=$(_objdir)
