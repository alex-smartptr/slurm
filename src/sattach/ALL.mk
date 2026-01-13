INSTALL_BIN += sattach

sattach.CFILES := $(call FileList,\
	attach.c \
	opt.c \
	sattach.c \
	sattach.wrapper.c \
)

sattach.CFILES_EXTRA = $(slurmfull.CFILES)

# debugging information is required for symbols in the attach
# module so that a debugger can attach to spawned tasks
$(call c2obj, $(Here)/attach.c): override DEBUG := 1


## Install & uninstall sattach.wrapper.c file
_installed_wrapper := $(DESTDIR)$(libdir)/slurm/src/sattach/sattach.wrapper.c
install: $(_installed_wrapper)
$(_installed_wrapper): $(Here)/sattach.wrapper.c
	$(call InstallFile,$<,$@)
uninstall::
	$(call RemoveFiles,$(_installed_wrapper))
