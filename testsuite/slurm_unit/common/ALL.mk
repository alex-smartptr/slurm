## log-test
TEST += log-test
log-test.CFILES := $(Here)/log-test.c
log-test.CFILES_EXTRA = $(slurmfull.CFILES)


ifdef HAVE_CHECK

# Template for simple one-file tests with check.
# Use as: $(call TestWithCheck,TEST_NAME)
#   where TEST_NAME.c is the test file in the current directory.
define TestWithCheck

TEST += $(notdir $(1))
$(notdir $(1)).CFILES := $(Here)/$(1).c
$(notdir $(1)).CFILES_EXTRA = $(slurmfull.CFILES)
$(notdir $(1)).LDLIBS := $(CHECK_LIBS)

endef


_checks := \
  data-test \
  dns-test \
  http-test \
  job-resources-test \
  pack-test \
  parse_time-test \
  reverse_tree-test \
  serializer-test \
  sluid-test \
  xahash-test \
  xhash-test \
  xstring-test \
  bitstring/bit_unfmt_hexmask-test \
  bitstring/bitstring-test \
  hostlist/hostlist_nth-test \
  slurm_protocol_defs/slurm_addto_char_list-test \
  slurm_protocol_defs/slurm_addto_id_char_list-test \
  slurm_protocol_defs/slurm_addto_mode_char_list-test \
  slurm_protocol_defs/slurm_addto_step_list-test \
  slurm_protocol_defs/xlate_array_task_str-test \
  slurm_protocol_pack/pack_job_alloc_info_msg-test \
  slurm_protocol_pack/pack_priority_factors-test \
  slurmdb_defs/slurmdb_addto_qos_char_list-test \
  slurmdb_pack/pack_user_rec-test \
  slurmdb_pack/pack_cluster_rec-test \
  slurmdb_pack/pack_used_limits-test \
  slurmdb_pack/pack_account_rec-test \
  slurmdb_pack/pack_coord_rec-test \
  slurmdb_pack/pack_cluster_acct_rec-test \
  slurmdb_pack/pack_clus_res_rec-test \
  slurmdb_pack/pack_federation_rec-test \
  slurmdb_pack/pack_accting_rec-test \
  slurmdb_pack/pack_assoc_rec-test \
  slurmdb_pack/pack_assoc_usage-test \
  slurmdb_pack/pack_assoc_rec_with_usage-test \
  slurmdb_pack/pack_event_cond-test \
  slurmdb_pack/pack_event_rec-test \

ifdef HAVE_LUA
  _checks += lua-test
endif


# Instantiate template for each check.
# The result can be examined via the target `print-_common_checks`,
# if you need to debug this makefile.
_common_checks := $(foreach C,$(_checks),$(call TestWithCheck,$(C)))
$(eval $(_common_checks))


## tests that need to load plugins
serializer-test.CPPDEFINES := SLURM_PLUGIN_DIR=$(PLUGINDIR)


## lua-test extras
lua-test.CFILES_EXTRA += $(slurm_lua.CFILES)
lua-test.CPPFLAGS := $(lua_CFLAGS) -DLUA_TEST_SCRIPT=\"$(Here)/lua-test.lua\"
lua-test.LDLIBS += $(lua_LIBS)

endif # HAVE_CHECK
