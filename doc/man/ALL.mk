## man files

_man1_files := $(call FileList, man1/, \
	sacct.1 \
	sacctmgr.1 \
	salloc.1 \
	sattach.1 \
	sbatch.1 \
	sbcast.1 \
	scancel.1 \
	scontrol.1 \
	scrun.1 \
	scrontab.1 \
	sdiag.1 \
	sinfo.1 \
	slurm.1 \
	sprio.1 \
	squeue.1 \
	sreport.1 \
	srun.1 \
	sshare.1 \
	sstat.1 \
	strigger.1 \
)

ifdef BUILD_HDF5
  _man1_files += $(Here)/man1/sh5util.1
endif

ifdef BUILD_SVIEW
  _man1_files += $(Here)/man1/sview.1
endif

_man5_files := $(call FileList, man5/, \
	acct_gather.conf.5 \
	burst_buffer.conf.5 \
	cgroup.conf.5 \
	gres.conf.5 \
	helpers.conf.5 \
	job_container.conf.5 \
	mpi.conf.5 \
	namespace.yaml.5 \
	oci.conf.5 \
	resources.yaml.5 \
	slurm.conf.5 \
	slurmdbd.conf.5 \
	topology.conf.5 \
	topology.yaml.5 \
)

_man8_files := $(call FileList, man8/, \
	sackd.8 \
	slurmctld.8 \
	slurmd.8 \
	slurmdbd.8 \
	slurmrestd.8 \
	slurmstepd.8 \
	spank.8 \
)

## Install man files

_installed_man_files := $(patsubst $(Here)/%, $(DESTDIR)$(mandir)/%, \
  $(_man1_files) \
  $(_man5_files) \
  $(_man8_files) \
)
install: $(_installed_man_files)
$(_installed_man_files): $(DESTDIR)$(mandir)/%: $(Here)/%
	$(call InstallFile,$<,$@)

## Uninstall man files

uninstall::
	$(call RemoveFiles,$(_installed_man_files))


##
## Generate HTML files from man files (if we have `man2html`).

ifdef HAVE_MAN2HTML

#
# Template to convert a manX file into the base HTML filename.
# doc/man/man1/foo.1 => foo.html
# Use as $(call man2html,MANFILE)
man2html = $(notdir $(basename $(1))).html

#
# The man2html.py script always places its output in the current working
# directory.
MAN2HTML := $(ROOTDIR)/doc/man/man2html.py
MAN2HTML_ARGS := \
  $(SLURM_MAJOR).$(SLURM_MINOR) \
  $(ROOTDIR)/doc/html/header.txt \
  $(ROOTDIR)/doc/html/footer.txt

#
# Use as $(call Man2Html,MANFILE,HTMLFILE)
Man2Html = \
  ( cd $(BUILDDIR) \
    && $(MAN2HTML) $(MAN2HTML_ARGS) $(ROOTDIR)/$(1) >/dev/null \
  ) && mv $(BUILDDIR)/$(man2html) $(2)


# manX files to be processed into HTML
_man2html_files := \
  $(filter-out %/slurm.1, $(_man1_files) $(_man5_files) $(_man8_files))

# The HTML files we want to generate from them.
_html_man_files := $(foreach F,$(_man2html_files),$(HTMLDIR)/$(call man2html,$(F)))
doc: $(_html_man_files)

# A rule to generate each HTML file.
define Man2HtmlRules

$(HTMLDIR)/$(man2html): $(1) | $(HTMLDIR) $(BUILDDIR)
	@echo "MAN2   > $$@"
	$(call Man2Html,$(1),$$@)

endef
MAN2HTML_RULES := $(foreach F,$(_man2html_files),$(call Man2HtmlRules,$(F)))
$(eval $(MAN2HTML_RULES))

# Add to the list of HTML files to be installed (used by parent ALL.mk)
_html_files += $(_html_man_files)


endif # HAVE_MAN2HTML
