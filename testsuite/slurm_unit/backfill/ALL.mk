## backfill-test

ifdef HAVE_CHECK

TEST += backfill-test

backfill-test.CFILES := $(call FileList, \
	backfill_test.c \
	dummy_functions.c \
)

backfill-test.CFILES_EXTRA = \
  $(slurmfull.CFILES) \
  $(addprefix src/plugins/sched/backfill/, \
	backfill.c \
	oracle.c \
  ) \
  $(addprefix src/slurmctld/, \
	job_scheduler.c \
	licenses.c \
	node_scheduler.c \
  )

backfill-test.LDLIBS := $(CHECK_LIBS)

# Ad-hoc code to wrap dummy functions. Reads wrap_functions.list, and generates:
# - a linker `response` file that contains --wrap= options
# - a header file that renames FUNCTION to __wrap_FUNCTION

_objdir       := $(OBJDIR)/$(Here)
_wraplist     := $(Here)/wrap_functions.list
_wrapheader   := $(_objdir)/wrap_functions.h
_wrapresponse := $(_objdir)/wrap_functions.response

$(backfill-test.CFILES): $(_wrapheader) $(_wrapresponse)
$(_wrapheader): $(_wraplist) | $$(@D)
	@echo "SED    > $@"
	$(SED) -e 's/^#.*//g' -e 's/\(..*\)/#define \1 __wrap_\1/' $< > $@
$(_wrapresponse): $(_wraplist) | $$(@D)
	@echo "SED    > $@"
	$(SED) -e 's/^#.*//g' -e 's/\(..*\)/--wrap=\1/' $< > $@

backfill-test.CPPDEFINES := HAVE_WRAP
backfill-test.CPPINCLUDES := $(_objdir) src/plugins/sched/backfill
backfill-test.LDFLAGS := -Wl,@$(_wrapresponse) -Wl,--unresolved-symbols=ignore-all
backfill-test.ARGS := -c$(_objdir)

# Customise the slurm.conf for this environment.

_slurm_conf := $(_objdir)/slurm.conf
_topology_conf := $(_objdir)/topology.conf
backfill-test: $(_slurm_conf) $(_topology_conf)
$(_slurm_conf): $(Here)/slurm.conf
	@echo "SED    > $@"
	$(SED) 's%PluginDir=.*$$%PluginDir=$(PLUGINDIR)%g' $< > $@
$(_topology_conf): $(Here)/topology.conf
	@echo "COPY   > $@"
	$(INSTALL) $< $@

endif # HAVE_CHECK
