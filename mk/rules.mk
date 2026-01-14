## Late-bound variables used by the rules

# For convenience, count everything defined as INSTALL_BIN & INSTALL_SBIN
# as also being an EXE.
__exe = $(sort $(EXE) $(INSTALL_BIN) $(INSTALL_SBIN))

# All phony targets
__targets = $(sort $(__exe) $(TEST) $(LIB) $(SOLIB) $(PLUGIN) $(DUMMY))


## -- Files --

# Static object files
OBJFILES :=
# PIC object files
POBFILES :=
# Binary data files
BINFILES :=
# Dependency files
DEPFILES :=

# For target `foo`, we expect CFILES.foo to be set.
# Calculate values for OBJFILES.foo, POBFILES.foo, and DEPFILES.foo, and
# accumulate those in OBJFILES, POBFILES, and DEPFILES.

# Helper used by TargetVars. Generates a rule to set a build
# variable, just for the specific target.
# Use as:
#   $(call __compile_target_rule,<target>,<varname>)
# Generates:
#   $(<target>.OBJFILES) $(<target>.POBFILES): <varname> += $(<target>.<varname>)
__compile_target_rule = $(if $(and $($(1).$(2)),$($(1).CFILES)),\
$$($(1).OBJFILES) $$($(1).POBFILES): $(2) += $($(1).$(2))$(NEWLINE))

# Note: CFLAGS.foo is added to LDFLAGS *not* CFLAGS, in order to prevent the
# text from being repeated in object compile recipes.
__link_target_rule = $(if \
  $($(1).CFLAGS),$(2): LDFLAGS += $($(1).CFLAGS)$(NEWLINE))$(if \
  $($(1).LDFLAGS),$(2): LDFLAGS += $($(1).LDFLAGS)$(NEWLINE))$(if \
  $($(1).LDLIBS),$(2): LDLIBS += $($(1).LDLIBS)$(NEWLINE))$(if \
  $($(1).LIBS),$(2): LIBS += $($(1).LIBS)$(NEWLINE))

define TargetVars

# $(1)
$(1).OBJFILES := $$(call c2obj,$$($(1).CFILES))
$(1).POBFILES := $$(call c2pob,$$($(1).CFILES))
$(1).BINFILES := $$(call txt2obj,$$($(1).TXTFILES))
$(call \
  __compile_target_rule,$(1),CPPFLAGS)$(call \
  __compile_target_rule,$(1),CPPINCLUDES)$(call \
  __compile_target_rule,$(1),CPPDEFINES)$(call \
  __compile_target_rule,$(1),CFLAGS)
$(1).OBJFILES += $$(call c2obj,$$($(1).CFILES_EXTRA))
$(1).POBFILES += $$(call c2pob,$$($(1).CFILES_EXTRA))

OBJFILES += $$($(1).OBJFILES)
POBFILES += $$($(1).POBFILES)
BINFILES += $$($(1).BINFILES)

endef
TARGET_VARS := $(foreach T,$(__targets),$(call TargetVars,$(T)))
$(eval $(TARGET_VARS))

# Calculate final list of unique generated files, and OBJDIRS
OBJFILES := $(sort $(OBJFILES))
POBFILES := $(sort $(POBFILES))
BINFILES := $(sort $(BINFILES))
DEPFILES := $(sort $(call o2dep,$(OBJFILES) $(POBFILES) $(BINFILES)))
OBJDIRS  := $(sort $(call Dir,$(DEPFILES)))


## -- Pattern rules --

# Compile static objects from C source (generate .dep files as a side-effect).
$(OBJFILES): $(OBJDIR)/%.$(OBJEXT):  %.c | $$(@D)
	@echo "CC       $<"
	$(call CcDepCompile,$<,$@,$(OBJDIR)/$*.dep,-fno-pic -fno-pie)

# Compile PIC objects from C source (generate .dep files as a side-effect).
$(POBFILES): $(POBDIR)/%.$(OBJEXT):  %.c | $$(@D)
	@echo "CC -fpic $<"
	$(call CcDepCompile,$<,$@,$(POBDIR)/$*.dep,-fpic)

# Embed a text file into a binary object (generate .dep files as a side-effect).
$(BINFILES): $(OBJDIR)/%.$(OBJEXT):  %.txt | $$(@D)
	@echo "EMBED    $<"
	cd $(<D) ; $(LD) -m elf_x86_64 -r -o $(abspath $@.tmp) -z noexecstack --format=binary $(<F)
	$(OBJCOPY) --rename-section .data=.rodata,alloc,load,readonly,data,contents $@.tmp
	$(call MoveFile,$@.tmp,$@)
	echo "$@: $<" > $(OBJDIR)/$*.dep


## -- Targets --

# User code can add anything it likes to the `default` target.
.PHONY: default plugins tests check install uninstall $(__targets)
default: $(sort $(__exe) $(LIB) $(SOLIB) $(PLUGIN)) tests
plugins: $(PLUGIN)
tests: $(call test2path,$(TEST)) # Builds the test cases
check: $(TEST) # Runs the test cases
install:
uninstall::


#  -------------
# | Directories |
#  -------------
$(BUILDDIR) $(OBJDIRS) $(BINDIR) $(LIBDIR) $(PLUGINDIR) \
$(TESTDIR) $(HTMLDIR) $(ETCDIR):
	$(call MakeDir,$@)


#  -------------
# | Executables | (except test cases).
#  -------------
#   This very simple build model just links objects into an executable. There
#   are no intermediate libraries or archives.
#   Use target-dependent variables for options that vary between executables.
define CcExeRule

$(1): $(exe2path)
$(exe2path): $$($(1).OBJFILES) $$($(1).BINFILES) | $(BINDIR)
	@echo "LD     > $$@"
	$$(call CcLinkExe,$$@,$$^,,-fno-pic -no-pie)
$(call __link_target_rule,$(1),$(exe2path))

endef
EXE_RULES := $(foreach E,$(__exe),$(call CcExeRule,$(E)))
$(eval $(EXE_RULES))


#  -------
# | Tests |
#  -------
#  The rule that actually runs the test streams all output into a temp file,
#  and echos it out at the end. Allows tests to run in parallel without
#  jumbling up the output.
define TestRule

tests: $(test2path)
$(test2path): $$($(1).OBJFILES) $$($(1).BINFILES) | $(TESTDIR)
	@echo "LD     > $$@"
	$$(call CcLinkExe,$$@,$$^,,-fno-pic -no-pie)
$(call __link_target_rule,$(1),$(test2path))
$(1): $(test2path)
	@out="$(test2log).tmp.$$$$$$$$" ; \
	echolog() { printf "> \033[1m$(test2log)\033[0m\n" >>$$$$out ; /usr/bin/cat $(test2log) >>$$$$out ; printf "%s\n\n" "----" >>$$$$out ; }; \
	printf "TEST     $$@" > $$$$out ; \
	$($(1).ENVIRON) $(test2path) $($(1).ARGS) >$(test2log) 2>&1 \
	  && ( printf " \033[32;1m[PASS]\033[0m\n" >>$$$$out ; $(if $(SILENT:1=),echolog;) ) \
	  || ( printf " \033[31;1m[FAIL]\033[0m\n" >>$$$$out ; echolog; ) ; \
	/bin/cat $$$$out ; rm -rf $$$$out

endef
TEST_RULES := $(foreach T,$(TEST),$(call TestRule,$(T)))
$(eval $(TEST_RULES))


#  ------------------
# | Static libraries |
#  ------------------
define CcStaticLibRule

$(1): $(lib2path)
$(lib2path): $$($(1).OBJFILES) $$($(1).BINFILES) | $(LIBDIR)
	@echo "AR     > $$@"
	$$(call BuildStatic,$$@,$$^)

endef
LIB_RULES := $(foreach L,$(LIB),$(call CcStaticLibRule,$(L)))
$(eval $(LIB_RULES))


#  ------------------
# | Shared libraries |
#  ------------------
define CcSharedLibRule

$(1): $(solib2path)
$(solib2path): $$($(1).POBFILES) $$($(1).BINFILES) | $(LIBDIR)
	@echo "LD     > $$@"
	$$(call CcBuildShared,$$@,$$^,$$($(1).LIBS),$(Soname))
$(call __link_target_rule,$(1),$(solib2path))

endef
SOLIB_RULES := $(foreach L,$(SOLIB),$(call CcSharedLibRule,$(L)))
$(eval $(SOLIB_RULES))


#  ---------
# | Plugins | (a special kind of shared library)
#  ---------
define CcPluginRule

$(1): $(plugin2path)
$(plugin2path): $$($(1).POBFILES) $$($(1).BINFILES) | $(PLUGINDIR)
	@echo "LD     > $$@"
	$$(call CcBuildShared,$$@,$$^,$$($(1).LIBS),$$(@F))
$(call __link_target_rule,$(1),$(plugin2path))

endef
PLUGIN_RULES := $(foreach P,$(PLUGIN),$(call CcPluginRule,$(P)))
$(eval $(PLUGIN_RULES))

# Extra CPP define for plugins.
# Apply the extra define to every object that is ONLY built for a plugin.
plugin_objects := $(filter-out \
  $(sort $(foreach T,$(__exe) $(TEST) $(LIB) $(SOLIB),$($(T).POBFILES))), \
  $(sort $(foreach P,$(PLUGIN),$($(P).POBFILES))))
$(plugin_objects): CPPDEFINES += SLURM_PLUGIN_DEBUG


#  ------------------
# | Install binaries |
#  ------------------
#   Dependencies are slightly counter-intuitive here.
#   For an example binary APP, install to /usr/bin...
#       install: /usr/bin/APP
#       /usr/bin/APP: APP
#               install -D -t /usr/bin build/bin/APP
#   The executable rules (above) have already declared the dependency...
#       APP: build/bin/APP
#   APP in included in the dependency chain to ensure that target-specific
#   variable settings are used when building for install. If the user tries to
#   build an executable directly, then it still won't work. So do not try...
#       $ make build/bin/APP
#   always use this instead...
#       $ make APP
#
#   Use as $(call InstallBin, EXE, INSTALL_DIRECTORY)
define InstallBin

install: $(2)/$(1)
$(2)/$(1): $(exe2path)
	$(call SimpleRecipe,$(INSTALL_PROGRAM) -D -t $(2) $(exe2path))

endef

install_bin_dir  := $(DESTDIR)$(bindir)
install_sbin_dir := $(DESTDIR)$(sbindir)
INSTALL_BIN_RULES := \
  $(foreach I,$(INSTALL_BIN),$(call InstallBin,$(I),$(install_bin_dir))) \
  $(foreach I,$(INSTALL_SBIN),$(call InstallBin,$(I),$(install_sbin_dir)))
$(eval $(INSTALL_BIN_RULES))

uninstall::
	$(call RemoveFiles,$(addprefix $(install_bin_dir)/,$(INSTALL_BIN)))
	$(call RemoveFiles,$(addprefix $(install_sbin_dir)/,$(INSTALL_SBIN)))


#  --------------------------
# | Install shared libraries |
#  --------------------------
#   Use as $(call InstallSharedLib, LIB, INSTALL_DIRECTORY)
define InstallSharedLib

$(1).__lib   := $(2)/$(SharedLib)$(FullVersion)
$(1).__links := $(if $(LibVersion),$(2)/$(SharedLib) $(2)/$(SharedLib)$(MajorVersion))
install: $$($(1).__lib) $$($(1).__links)
$$($(1).__lib): $(solib2path)
	$(call SimpleRecipe,$(INSTALL_PROGRAM) -D -T $$< $$@)
$(if $(LibVersion),$$($(1).__links): $$($(1).__lib)\
$(NEWLINE)	$(call SimpleRecipe,$(LN_S) -f $$(<F) $$(@F),cd $$(@D)))
uninstall::
	$(call RemoveFiles,$$($(1).__lib) $$($(1).__links))

endef
INSTALL_SOLIB_RULES := \
  $(foreach I,$(SOLIB),$(call InstallSharedLib,$(I),$(DESTDIR)$(libdir)))
$(eval $(INSTALL_SOLIB_RULES))


#  -----------------
# | Install headers |
#  -----------------
installed_headers = $(addprefix $(DESTDIR)$(includedir)/,$(INSTALL_HEADERS))
install: $(installed_headers)
$(installed_headers): $(addprefix $(DESTDIR)$(includedir)/,%): %
	$(call SimpleRecipe,$(INSTALL_DATA) -D -t $(@D) $<)
uninstall::
	$(call RemoveFiles,$(installed_headers))


#  -----------------
# | Install plugins |
#  -----------------
installed_plugins = \
  $(foreach I,$(PLUGIN),$(DESTDIR)$(libdir)/slurm/$(call Plugin,$(I)))
install: $(installed_plugins)
$(installed_plugins): $(DESTDIR)$(libdir)/slurm/%: $(PLUGINDIR)/%
	$(call SimpleRecipe,$(INSTALL_PROGRAM) -D -t $(@D) $<)
uninstall::
	$(call RemoveFiles,$(installed_plugins))


# Clean
.PHONY: clean
clean::
	$(call RemoveAll, $(BUILDDIR))
	$(call RemoveFiles, $(CLEANFILES))

# For troubleshooting, print variable values. E.g. make print-CFLAGS
print-%:
	@$(file >>/dev/stdout,$* :=) true
	@$(file >>/dev/stdout,"""$($*)""")
value-%:
	@$(file >>/dev/stdout,$* value) true
	@$(file >>/dev/stdout,"""$(value $*)""")


## -- Bring in generated dependency files --

ifneq "$(MAKECMDGOALS)" "clean"
  -include $(DEPFILES)
endif
