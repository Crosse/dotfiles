GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RESET  := $(shell tput -Txterm sgr0)

# From https://gist.github.com/prwhite/8168133#gistcomment-1727513
# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
	%help; \
	while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z0-9\-_]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
	print "usage: make [target]\n\n"; \
	for (sort keys %help) { \
	print "${WHITE}$$_:${RESET}\n"; \
	for (@{$$help{$$_}}) { \
	$$sep = " " x (32 - length $$_->[0]); \
	print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
	}; \
	print "\n"; }

help: ##@other Show this help.
help:
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

info:				##@other Print out environment as detected by this Makefile.
info: _info $(UNAME)_info
_info:
	$(info Detected platform: $(UNAME))
	$(info Using $(DOWNLOADER) to download files)
ifdef GO
	$(info Detected Go ($(shell $(GO) version)))
endif
ifdef GIT
	$(info Detected Git ($(shell $(GIT) version)))
endif
ifdef FONT_INSTALL
	$(info Detected font-install at $(FONT_INSTALL))
endif
	@true

.PHONY: help info _info
