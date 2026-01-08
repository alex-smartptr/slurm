## -- File name extensions --

# Object files.
OBJEXT  := o

# Shared object files.
SOEXT   := so

# Archive files.
ARCHEXT := a

# Executable files (optional)
EXEEXT  :=

__soext   = $(SOEXT:%=.%)
__exeext  = $(EXEEXT:%=.%)

## -- Versions --

#
# Lookup the version of a library (foo.VERSION), if set. E.g. foo => 1.2.3
LibVersion = $($(1).VERSION)

#
# Calculate the MAJOR version of a library. E.g. foo => .1
MajorVersion = $(if $(LibVersion),.$(word 1,$(subst ., ,$(LibVersion))))

#
# Calculate the FULL version of a library. E.g. foo => .1.2.3
FullVersion = $(if $(LibVersion),.$(LibVersion))


## -- File name templates --

#
# Template for library link line.
# Use as -l$(call Libname,NAME)
Libname = $(strip $(1))

#
# Template for executable file name.
# Use as: -o $(call Exe,NAME)
Exe = $(1:%=%$(__exeext))

#
# Template for test executable file name.
# Use as: -o $(call Test,NAME)
Test = $(1:%=%$(__exeext))

#
# Template for static library file name.
# Use as: -o $(call StaticLib,NAME)
StaticLib = lib$(Libname)$(ARCHEXT:%=.%)

#
# Template for shared library file name.
# Use as: -o $(call SharedLib,NAME)
SharedLib = $(patsubst %,lib%$(__soext),$(Libname))

#
# Template for shared library soname. Example libfoo.so.1
# Use as: $(call Soname,NAME)
Soname = $(SharedLib)$(MajorVersion)

#
# Template for plugin file name.
# Use as: -o $(call Plugin,NAME)
Plugin = $(1:%=%$(__soext))
