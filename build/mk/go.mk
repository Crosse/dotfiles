GOENV_PATH := $(ANYENV_PATH)/envs/goenv

$(GOENV_PATH): $(ANYENV_PATH)
	eval "$$($(ANYENV_PATH)/bin/anyenv init -)" && \
	    ${HOME}/.anyenv/bin/anyenv install -s goenv

$(GOENV_PATH)/versions/$(GO_VER):
	eval "$$(${HOME}/.anyenv/bin/anyenv init -)" && \
	    $(GOENV_PATH)/bin/goenv install $(GO_VER)


goenv:			##@env Install goenv via anyenv
goenv: $(GOENV_PATH)

go: $(GOENV_PATH)/versions/$(GO_VER)

go-tools:			##@languages Install some useful Go tools (golint, cover).
go-tools: $(GOROOT)
	@echo "==> Installing Go tools"
	$(GO) get -u github.com/golang/lint/golint
	$(GO) get -u golang.org/x/tools/cmd/cover


.PHONY: goenv go go-tools
