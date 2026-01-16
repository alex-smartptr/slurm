# All HTML files placed into HTMLDIR that are to be installed.
_html_files :=

include doc/man/ALL.mk
include doc/html/ALL.mk

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
