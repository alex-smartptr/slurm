# Makefile for hash plugins

## Common

hash_common_xkcp.CFILES := $(call FileList, common_xkcp/, \
	KangarooTwelve.c \
	KeccakHash.c \
	KeccakP-1600-opt64.c \
	KeccakSponge.c \
)


## hash_k12

PLUGIN += hash_k12
hash_k12.CFILES := $(Here)/k12/hash_k12.c
hash_k12.CFILES_EXTRA = $(hash_common_xkcp.CFILES)


## hash_sha3

PLUGIN += hash_sha3
hash_sha3.CFILES := $(Here)/sha3/hash_sha3.c
hash_sha3.CFILES_EXTRA = $(hash_common_xkcp.CFILES)
