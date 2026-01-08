ifdef WITH_HTTP_PARSER

## http_parser_libhttp_parser

PLUGIN += http_parser_libhttp_parser
http_parser_libhttp_parser.CFILES := $(Here)/libhttp_parser/libhttp_parser.c
http_parser_libhttp_parser.CPPFLAGS := $(HTTP_PARSER_CPPFLAGS)
http_parser_libhttp_parser.LDLIBS := $(HTTP_PARSER_LDFLAGS)

endif
