ifdef LINUX_BUILD

## namespace_tmpfs

PLUGIN += namespace_tmpfs
namespace_tmpfs.CFILES := $(call FileList, tmpfs/, \
	namespace_tmpfs.c \
	read_jcconf.c \
)


## namespace_linux

PLUGIN += namespace_linux
namespace_linux.CFILES := $(call FileList, linux/, \
	namespace_linux.c \
	read_nsconf.c \
)

endif
