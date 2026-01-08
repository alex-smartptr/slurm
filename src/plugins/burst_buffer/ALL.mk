# Makefile for burst buffer plugins

## Common

burst_buffer_common.CFILES := $(Here)/common/burst_buffer_common.c


ifdef WITH_JSON_PARSER

## datawarp

  PLUGIN += burst_buffer_datawarp
  burst_buffer_datawarp.CFILES      := $(Here)/datawarp/burst_buffer_datawarp.c
  burst_buffer_datawarp.CFILES_EXTRA = $(burst_buffer_common.CFILES)
  burst_buffer_datawarp.CPPFLAGS    := $(JSON_CPPFLAGS)
  burst_buffer_datawarp.LDLIBS      := $(JSON_LDFLAGS)


  # ?? Having this nested inside the `ifdef WITH_JSON_PARSER` matches the
  # ?? existing build, but I'm not 100% sure it's correct.
  # ?? burst_buffer_lua does not seem to require JSON
  ifdef HAVE_LUA
  
    ## lua
  
    PLUGIN += burst_buffer_lua
    burst_buffer_lua.CFILES := $(Here)/lua/burst_buffer_lua.c
    burst_buffer_lua.CFILES_EXTRA = \
      $(burst_buffer_common.CFILES) \
      $(slurm_lua.CFILES)
    burst_buffer_lua.CFLAGS := $(lua_CFLAGS)
    burst_buffer_lua.LDLIBS := $(lua_lIBS)

  endif

endif # WITH_JSON_PARSER
