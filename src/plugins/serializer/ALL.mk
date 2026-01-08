# Makefile for serializer plugins

## serializer_url_encoded

PLUGIN += serializer_url_encoded
serializer_url_encoded.CFILES := $(Here)/url-encoded/serializer_url_encoded.c


## serializer_json

ifdef WITH_JSON_PARSER
PLUGIN += serializer_json
serializer_json.CFILES := $(Here)/json/serializer_json.c
serializer_json.CPPFLAGS := $(JSON_CPPFLAGS)
serializer_json.LDLIBS := $(JSON_LDFLAGS)
endif


## serializer_yaml

ifdef WITH_YAML
PLUGIN += serializer_yaml
serializer_yaml.CFILES := $(Here)/yaml/serializer_yaml.c
serializer_yaml.LDLIBS := $(YAML_LDFLAGS)
endif
