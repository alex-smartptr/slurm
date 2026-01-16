
# HTML template files (.shtml)
_doc_shtml_files = $(call FileList, \
	accounting.shtml \
	add.shtml \
	api.shtml \
	authentication.shtml \
	big_sys.shtml \
	burst_buffer.shtml \
	certmgr.shtml \
	cgroups.shtml \
	cgroup_v2.shtml \
	classic_fair_share.shtml \
	cli_filter_plugins.shtml \
	configless_slurm.shtml \
	cons_tres.shtml \
	cons_tres_share.shtml \
	containers.shtml \
	contributor.shtml \
	core_spec.shtml \
	cpu_management.shtml \
	dist_plane.shtml \
	documentation.shtml \
	dynamic_nodes.shtml \
	elasticsearch.shtml \
	extra_constraints.shtml \
	faq.shtml \
	federation.shtml \
	gang_scheduling.shtml \
	gres.shtml \
	gres_design.shtml \
	hdf5_profile_user_guide.shtml \
	heterogeneous_jobs.shtml \
	high_throughput.shtml \
	hres.shtml \
	jobcomp_kafka.shtml \
	job_array.shtml \
	job_exit_code.shtml \
	job_launch.shtml \
	job_reason_codes.shtml \
	job_state_codes.shtml \
	job_submit_plugins.shtml \
	jwt.shtml \
	kubernetes.shtml \
	licenses.shtml \
	fair_tree.shtml \
	mail.shtml \
	man_index.shtml \
	mc_support.shtml \
	mcs.shtml \
	metrics.shtml \
	mpi_guide.shtml \
	multi_cluster.shtml \
	namespace.shtml \
	network.shtml \
	nss_slurm.shtml \
	openapi_release_notes.shtml \
	overview.shtml \
	pam_slurm_adopt.shtml \
	platforms.shtml \
	plugins.shtml \
	power_save.shtml \
	preempt.shtml \
	prep_plugins.shtml \
	priority_multifactor.shtml \
	priority_multifactor3.shtml \
	programmer_guide.shtml \
	prolog_epilog.shtml \
	qos.shtml \
	quickstart_admin.shtml \
	quickstart.shtml \
	related_software.shtml \
	release_notes.shtml \
	reservations.shtml \
	resource_binding.shtml \
	resource_limits.shtml \
	rest.shtml \
	rest_api.shtml \
	rest_clients.shtml \
	rest_quickstart.shtml \
	rosetta.shtml \
	sched_config.shtml \
	select_design.shtml \
	selinux.shtml \
	site_factor.shtml \
	slinky.shtml \
	slurm.shtml \
	tls.shtml \
	topology.shtml \
	tres.shtml \
	troubleshoot.shtml \
	upgrades.shtml \
	user_permissions.shtml \
	wckey.shtml \
)

# Static HTML data files
_doc_static_files := $(call FileList, \
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

## - Generate .html from .shtml

#
# Template to convert a XXX.shtml file into the base HTML filename.
# doc/html/foo.shtml => foo.html
# Use as $(call shtml2html,SHTMLFILE)
shtml2html = $(notdir $(basename $(1))).html

#
# The shtml2html.py script always places its output in the current working
# directory.
SHTML2HTML := $(ROOTDIR)/doc/html/shtml2html.py

#
# Use as $(call Shtml2Html,SHTMLFILE,HTMLFILE)
Shtml2Html = \
  ( cd $(BUILDDIR) \
    && $(SHTML2HTML) $(SLURM_MAJOR).$(SLURM_MINOR) $(ROOTDIR)/$(1) >/dev/null \
  ) && mv $(BUILDDIR)/$(shtml2html) $(2)


# $(HTMLDIR)/xxx.html files generated from xxx.shtml
_html_shtml_files := \
  $(patsubst $(Here)/%.shtml,$(HTMLDIR)/%.html,$(_doc_shtml_files))

$(_html_shtml_files): $(HTMLDIR)/%.html: $(Here)/%.shtml | $(HTMLDIR) $(BUILDDIR)
	@echo "SHTML  > $@"
	$(call Shtml2Html,$<,$@)

# Add to the list of HTML files to be installed (used by parent ALL.mk)
_html_files += $(_html_shtml_files)


## - Copy static files -> HTMLDIR

# These are files "installed" into the build directory.
# We copy all HTML into BUILDDIR/html/... so that these static files can be
# merged with the generated HTML (see above) and all viewed in the same place,
# prior to installation.
_html_static_files := $(patsubst $(Here)/%, $(HTMLDIR)/%,$(_doc_static_files))
$(_html_static_files): $(HTMLDIR)/%: $(Here)/%
	$(call InstallFile,$<,$@)

# Add to the list of HTML files to be installed (used by parent ALL.mk)
_html_files += $(_html_static_files)
