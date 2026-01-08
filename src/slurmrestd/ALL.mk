ifdef WITH_SLURMRESTD

INSTALL_SBIN += slurmrestd

slurmrestd.TXTFILES := $(Here)/usage.txt

slurmrestd.CFILES := $(call FileList,\
	http.c \
	operations.c \
	slurmrestd.c \
	openapi.c \
	rest_auth.c \
)

slurmrestd.CFILES_EXTRA = $(slurmfull.CFILES)

slurmrestd.CPPFLAGS := $(HTTP_PARSER_CPPFLAGS)
slurmrestd.LDLIBS := $(HTTP_PARSER_LDFLAGS)


# slurmrestd/plugins/auth/local
PLUGIN += rest_auth_local
rest_auth_local.CFILES := $(Here)/plugins/auth/local/local.c
rest_auth_local.CPPFLAGS := $(JSON_CPPFLAGS)


ifdef WITH_JWT
  # slurmrestd/plugins/auth/jwt (?? Is JSON_CPPFLAGS required?)
  PLUGIN += rest_auth_jwt
  rest_auth_jwt.CFILES := $(Here)/plugins/auth/jwt/jwt.c
  rest_auth_jwt.CPPFLAGS := $(JSON_CPPFLAGS)
endif


# slurmrestd/plugins/openapi/slurmctld
PLUGIN += openapi_slurmctld
openapi_slurmctld.CFILES := $(call FileList, plugins/openapi/slurmctld/, \
	api.c \
	assoc_mgr.c \
	control.c \
	diag.c \
	jobs.c \
	nodes.c \
	partitions.c \
	reservations.c \
)


# slurmrestd/plugins/openapi/slurmdbd
PLUGIN += openapi_slurmdbd
openapi_slurmdbd.CFILES := $(call FileList, plugins/openapi/slurmdbd/, \
	accounts.c \
	associations.c \
	api.c \
	cluster.c \
	config.c \
	diag.c \
	instances.c \
	jobs.c \
	qos.c \
	tres.c \
	users.c \
	wckeys.c \
)

endif # WITH_SLURMRESTD
