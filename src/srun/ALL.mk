INSTALL_BIN += srun

srun.CFILES := $(call FileList,\
	allocate.c \
	fname.c \
	launch.c \
	multi_prog.c \
	opt.c \
	srun.c \
	srun_job.c \
	srun_pty.c \
	srun.wrapper.c \
	step_ctx.c \
	task_state.c \
)
srun_debugger.CFILES := $(call FileList,\
	debugger.c \
)

# Always build debugger.o with debugging info.
# Enables spawned tasks to be debugged.
$(call c2targets, srun_debugger): override DEBUG := 1

srun.CFILES_EXTRA = \
  $(srun_debugger.CFILES) \
  $(bcast.CFILES) \
  $(slurmfull.CFILES) \


## Install & uninstall srun.wrapper.c file
_installed_wrapper := $(DESTDIR)$(libdir)/slurm/src/srun/srun.wrapper.c
install: $(_installed_wrapper)
$(_installed_wrapper): $(Here)/srun.wrapper.c
	$(call InstallFile,$<,$@)
uninstall::
	$(call RemoveFiles,$(_installed_wrapper))
