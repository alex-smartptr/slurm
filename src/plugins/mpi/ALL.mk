# Makefile for mpi plugins

## mpi_cray_shasta

PLUGIN += mpi_cray_shasta
mpi_cray_shasta.CFILES := $(call FileList, cray_shasta/, \
	apinfo.c \
	mpi_cray_shasta.c \
)


## mpi_pmi2

PLUGIN += mpi_pmi2
mpi_pmi2.CFILES := $(call FileList, pmi2/, \
	mpi_pmi2.c \
	agent.c \
	client.c \
	kvs.c \
	info.c \
	pmi1.c \
	pmi2.c \
	setup.c \
	spawn.c \
	tree.c \
	nameserv.c \
	ring.c \
)


ifdef HAVE_PMIX

  # Pick the highest numbered version available
  pmix_version := $(firstword \
    $(HAVE_PMIX_V6:1=6) \
    $(HAVE_PMIX_V5:1=5) \
    $(HAVE_PMIX_V4:1=4) \
    $(HAVE_PMIX_V3:1=3) \
    $(HAVE_PMIX_V2:1=2) \
  )

  PLUGIN += mpi_pmix
  mpi_pmix.CFILES := $(call FileList, pmix/, \
	pmixp_client_v$(pmix_version).c \
	mapping.c \
	mpi_pmix.c \
	pmixp_agent.c pmixp_client.c pmixp_nspaces.c pmixp_info.c \
	pmixp_server.c pmixp_state.c pmixp_io.c pmixp_utils.c pmixp_dmdx.c \
	pmixp_conn.c pmixp_dconn.c pmixp_dconn_tcp.c \
	pmixp_coll.c pmixp_coll_tree.c pmixp_coll_ring.c \
	$(if $(HAVE_UCX), pmixp_dconn_ucx.c) \
  )
  mpi_pmix.CPPDEFINES := HAVE_PMIX_VER=$(pmix_version)
  mpi_pmix.CPPFLAGS := \
    $(HWLOC_CPPFLAGS) $(UCX_CPPFLAGS) $(PMIX_V$(pmix_version)_CPPFLAGS)
  mpi_pmix.LDFLAGS := \
    $(HWLOC_LDFLAGS) $(UCX_LDFLAGS) $(PMIX_V$(pmix_version)_LDFLAGS)
  mpi_pmix.LDLIBS := \
    $(HWLOC_LIBS) $(UCX_LIBS) 

endif
