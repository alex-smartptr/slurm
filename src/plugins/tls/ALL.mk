# Makefile for tls plugins

## tls_none

PLUGIN += tls_none
tls_none.CFILES := $(Here)/none/tls_none.c


## tls_s2n

ifdef WITH_S2N
PLUGIN += tls_s2n
tls_s2n.CFILES := $(Here)/s2n/tls_s2n.c
tls_s2n.CPPFLAGS := $(S2N_CPPFLAGS)
tls_s2n.LDFLAGS := $(S2N_LDFLAGS)
tls_s2n.LDLIBS := $(S2N_LIBS)
endif
