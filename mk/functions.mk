## Late-bound variables used by the functions.
__cppflags = $(strip \
  $(CPPFLAGS) $(addprefix -I,$(CPPINCLUDES)) $(addprefix -D,$(CPPDEFINES)))
__cflags   = $(strip $(CFLAGS))
__ldflags  = $(strip $(LDFLAGS))
__ldlibs   = $(strip $(LDLIBS) $(addprefix -L,$(LIBPATHS)) $(addprefix -l,$(LIBS)))

#
# Convenience function. Filters for only .o and .a files.
# Using this allows link targets to depend upon arbitrary files (such as
# linker scripts) without those prerequisites ending up in the list of object
# files to link.
# Use as $(call __o_a, IGNORED, OBJECTS)
__o_a = $(filter %.$(OBJEXT) %.$(ARCHEXT),$(2))


## -- Make functions --

#
# Like $(dir ...), but strip off any trailing '/' in the result.
Dir = $(patsubst %/,%,$(dir $(1)))

#
# Strip off the directory part and extension from file names.
Base = $(notdir $(basename $(1)))

#
# Turn filenames in THE CURRENT directory into a clean list of filenames
# relative to ROOTDIR. (Compare: SubdirList, FileList)
# Use as $(call DirList,FILENAMES)
DirList = $(addprefix $(Here)/,$(1))

#
# Turn filenames in A LOCAL SUB-DIRECTORY into a clean list of filenames
# relative to ROOTDIR.
# Use as $(call SubdirList,SUBDIR,FILENAMES)
SubdirList = $(addprefix $(Here)/$(if $(1),$(1:%/=%)/),$(2))

#
# Turn local filenames into a clean list of filenames relative to ROOTDIR.
# Use as $(call FileList,FILENAMES) or
#        $(call FileList,SUBDIR,FILENAMES)
FileList = $(if $(strip $(2)),$(SubdirList),$(DirList))


## -- Recipe functions --

#
# Make a simple recipe that documents itself. When a separate @echo line
# would only repeat the content of the recipe.
# Use as $(call SimpleRecipe,CODE,[PREAMBLE])
SimpleRecipe = @(echo "$(1)"); $(if $(2),$(2); )$(1)

#
# Copy SRCFILE to DESTFILE with mode 0644. Make all directories above DESTFILE.
# Use as $(call InstallFile,SRCFILE,DESTFILE)
InstallFile = @(echo "INSTALL> $(2)"); $(INSTALL_DATA) -D $(1) $(2)

#
# Make a new directory (and any missing parents).
# Use as $(call MkDir,PATH)
MakeDir = $(MKDIR) -p $(1)

#
# Touch a file, create it if it doesn't exist.
# Use as $(call Touch,PATHS)
Touch = $(TOUCH) $(1)

#
# Remove files & directories, ignoring errors / missing files.
# Use as $(call RemoveAll,PATHS)
RemoveAll = $(if $(1),$(RM) -rf $(1))

#
# Remove files.
# Use as $(call RemoveFiles,PATHS)
RemoveFiles = $(if $(1),$(RM) -f $(1))

#
# Move a file
# Use as $(call MoveFile, SRC_PATH, DST_PATH)
MoveFile = $(MV) $(1) $(2)

#
# Compile an object from C source. Generate a .dep as a side-effect.
# Use as $(call CcDepCompile, SOURCE, OBJECT, DEPFILE, FLAGS)
CcDepCompile = \
  $(CC) -o $(2)  -c $(__cppflags) $(4) $(__cflags) -MMD -MP -MF $(3) -MT $(2) $(1)

#
# Link an executable from (C) objects.
# Use as: $(call CcLinkExe, EXE, OBJECTS, LIBS, FLAGS)
CcLinkExe = $(CC) -o $(1)  $(strip $(LINK_STATIC:1=-Wl,-static) \
 $(4) $(__cflags) $(__ldflags) \
 $(__o_a) $(filter %.$(ARCHEXT),$(2) $(2)) \
 $(__ldlibs) $(3) \
 $(LINK_STATIC:1=-Wl,-call_shared))

#
# Construct a shared library.
# Use as: $(call CcBuildShared, OUTPUTFILE, OBJECTS, LIBS, SONAME)
CcBuildShared = $(CC) -shared -o $(1)  $(strip \
 -fpic $(__cflags) $(__ldflags) -Wl,-soname,$(4) \
 $(__o_a) \
 $(__ldlibs) $(3))

#
# Construct a static library from object files
# Use as: $(call BuildStatic, OUTPUTFILE, OBJECTS)
BuildStatic = $(AR) $(ARFLAGS) $(1) $(__o_a)


## -- File name transformations --

exe2path    = $(addprefix $(BINDIR)/,$(Exe))
test2path   = $(addprefix $(TESTDIR)/,$(Test))
test2log    = $(addprefix $(TESTDIR)/,$(Test).log)
lib2path    = $(addprefix $(LIBDIR)/,$(StaticLib))
solib2path  = $(addprefix $(LIBDIR)/,$(SharedLib))
plugin2path = $(addprefix $(PLUGINDIR)/,$(Plugin))
c2obj       = $(addprefix $(OBJDIR)/,$(1:.c=.$(OBJEXT)))
c2pob       = $(addprefix $(POBDIR)/,$(1:.c=.$(OBJEXT)))
txt2obj     = $(addprefix $(OBJDIR)/,$(1:.txt=.$(OBJEXT)))
c2dep       = $(addprefix $(OBJDIR)/,$(1:.c=.dep))
o2dep       = $(patsubst %.$(OBJEXT),%.dep,$(1))

#
# Convenience function for rules files.
# Calculate all object file targets (PIC and non-PIC) from $(CFILES.$(1))
# Use as: $(call c2targets,foo)
c2targets = \
  $(call c2obj,$(CFILES.$(strip $(1)))) \
  $(call c2pob,$(CFILES.$(strip $(1))))


## Useful aliases

#
# Get the full path to the current file being parsed
Here = $(patsubst $ROOTDIR/%,%,$(call Dir,$(lastword $(MAKEFILE_LIST))))
