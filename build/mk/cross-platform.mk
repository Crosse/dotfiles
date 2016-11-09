CURL := $(shell command -v curl;)
WGET := $(shell command -v wget;)
DOWNLOADER := "none"
DL_OPTS ?=

ifdef CURL
    DOWNLOADER := curl
    DL_OPTS := -Lo-
else ifdef WGET
    DOWNLOADER := wget
    DL_OPTS := -O-
else
    $(error Neither curl nor wget are installed on this system.)
endif
