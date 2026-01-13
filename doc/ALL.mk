## man files

_man1_files := $(call FileList, man/man1/, \
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

_man5_files := $(call FileList, man/man5/, \
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

_man8_files := $(call FileList, man/man8/, \
	sackd.8 \
	slurmctld.8 \
	slurmd.8 \
	slurmdbd.8 \
	slurmrestd.8 \
	slurmstepd.8 \
	spank.8 \
)

## Install man files

_installed_man_files := $(patsubst $(Here)/man/%, $(DESTDIR)$(mandir)/%, \
  $(_man1_files) \
  $(_man5_files) \
  $(_man8_files) \
)
install: $(_installed_man_files)
$(_installed_man_files): $(DESTDIR)$(mandir)/%: $(Here)/man/%
	$(call InstallFile,$<,$@)

## Uninstall man files

uninstall::
	$(call RemoveFiles,$(_installed_man_files))


# Static HTML files
_static_html = $(call FileList, html/, \
	accounting.html \
	add.html \
	api.html \
	authentication.html \
	big_sys.html \
	burst_buffer.html \
	certmgr.html \
	cgroups.html \
	cgroup_v2.html \
	classic_fair_share.html \
	cli_filter_plugins.html \
	configless_slurm.html \
	cons_tres.html \
	cons_tres_share.html \
	containers.html \
	contributor.html \
	core_spec.html \
	cpu_management.html \
	dist_plane.html \
	documentation.html \
	dynamic_nodes.html \
	elasticsearch.html \
	extra_constraints.html \
	faq.html \
	federation.html \
	gang_scheduling.html \
	gres.html \
	gres_design.html \
	hdf5_profile_user_guide.html \
	heterogeneous_jobs.html \
	high_throughput.html \
	hres.html \
	jobcomp_kafka.html \
	job_array.html \
	job_exit_code.html \
	job_launch.html \
	job_reason_codes.html \
	job_state_codes.html \
	job_submit_plugins.html \
	jwt.html \
	kubernetes.html \
	licenses.html \
	fair_tree.html \
	mail.html \
	man_index.html \
	mc_support.html \
	mcs.html \
	metrics.html \
	mpi_guide.html \
	multi_cluster.html \
	namespace.html \
	network.html \
	nss_slurm.html \
	openapi_release_notes.html \
	overview.html \
	pam_slurm_adopt.html \
	platforms.html \
	plugins.html \
	power_save.html \
	preempt.html \
	prep_plugins.html \
	priority_multifactor.html \
	priority_multifactor3.html \
	programmer_guide.html \
	prolog_epilog.html \
	qos.html \
	quickstart_admin.html \
	quickstart.html \
	related_software.html \
	release_notes.html \
	reservations.html \
	resource_binding.html \
	resource_limits.html \
	rest.html \
	rest_api.html \
	rest_clients.html \
	rest_quickstart.html \
	rosetta.html \
	sched_config.html \
	select_design.html \
	selinux.html \
	site_factor.html \
	slinky.html \
	slurm.html \
	tls.html \
	topology.html \
	tres.html \
	troubleshoot.html \
	upgrades.html \
	user_permissions.html \
	wckey.html \
)

# Static HTML data files
_static_html += $(call FileList, html/, \
	allocation_pies.gif \
	arch.gif \
	configurator.html \
	configurator.easy.html \
	cg_hierarchy.jpg \
	entities.gif \
	example_usage.gif \
	fonts.css \
	fonts.ttf \
	hdf5_task_attr.png \
	hdf5_job_outline.png \
	ibm_pe_fig1.png \
	ibm_pe_fig2.png \
	jobcomp_kafka_fig1.png \
	jquery.min.js \
	k_function.gif \
	mc_support.gif \
	network_failover.gif \
	network_federation.gif \
	network_multi_cluster.gif \
	network_srun.gif \
	network_standard.gif \
	node_lifecycle.png \
	plane_ex1.gif \
	plane_ex2.gif \
	plane_ex3.gif \
	plane_ex4.gif \
	plane_ex5.gif \
	plane_ex6.gif \
	plane_ex7.gif \
	reset.css \
	openapi.css \
	slurm_logo.png \
	schedmd.png \
	slurm.css \
	squeue_color.png \
	style.css \
	topo_ex1.gif \
	topo_ex2.gif \
	usage_pies.gif \
)

# These are files "installed" into the build directory.
# We copy all HTML into BUILDDIR/html/... so that these static files can be
# merged with the generated HTML (see below) and all viewed in the same place,
# prior to installation.
_html_files := $(patsubst $(Here)/html/%, $(HTMLDIR)/%,$(_static_html))
$(_html_files): $(HTMLDIR)/%: $(Here)/html/%
	$(call InstallFile,$<,$@)


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
# The HTML files we want to generate from them
_html_files += $(foreach F,$(_man2html_files),$(HTMLDIR)/$(call man2html,$(F)))

# A rule to generate each HTML file.
define HtmlGenRules

$(HTMLDIR)/$(man2html): $(1) | $(HTMLDIR) $(BUILDDIR)
	@echo "HTML   > $$@"
	$(call Man2Html,$(1),$$@)

endef
HTML_GEN_RULES := $(foreach F,$(_man2html_files),$(call HtmlGenRules,$(F)))
$(eval $(HTML_GEN_RULES))

endif # HAVE_MAN2HTML


## Build targets for the unified BUILDDIR/html directory.

.PHONY: html
html: $(_html_files)
default: html


## Install HTML files

_install_htmldir := $(DESTDIR)${datadir}/doc/${PACKAGE}-${SLURM_VERSION_STRING}/html
_installed_html_files := $(_html_files:$(HTMLDIR)/%=$(_install_htmldir)/%)
install: $(_installed_html_files)
$(_installed_html_files): $(_install_htmldir)/%: $(HTMLDIR)/%
	$(call InstallFile,$<,$@)

## Uninstall

uninstall::
	$(call RemoveFiles,$(_installed_html_files))
