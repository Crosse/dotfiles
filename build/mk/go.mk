GOENV_PATH := $(ANYENV_PATH)/envs/goenv

$(GOENV_PATH)/versions/%: |$(GOENV_PATH)
	eval "$$(${HOME}/.anyenv/bin/anyenv init -)" && \
	    $(GOENV_PATH)/bin/goenv install $* &&	\
	    $(GOENV_PATH)/bin/goenv global $*

goenv:				##@env Install goenv via anyenv.
goenv: $(GOENV_PATH)

go:				##@languages Install Go (using goenv).
go: $(GOENV_PATH)/versions/$(GO_VER)

go-tools:			##@languages Install some useful Go tools (golint, cover).
go-tools: $(GOROOT)
	@echo "==> Installing Go tools"
	$(GO) get -u github.com/golang/lint/golint
	$(GO) get -u golang.org/x/tools/cmd/cover


.PHONY: goenv go go-tools
