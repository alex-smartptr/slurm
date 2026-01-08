conmgr.CFILES := $(call FileList,\
	con.c \
	conmgr.c \
	delayed.c \
	io.c \
	poll.c \
	polling.c \
	rpc.c \
	signals.c \
	tls.c \
	tls_fingerprint.c \
	watch.c \
	work.c \
	workers.c \
	$(if $(HAVE_EPOLL), epoll.c) \
)


