GOENV_PATH := $(ANYENV_PATH)/envs/goenv

$(GOENV_PATH)/versions/%: $(GOENV_PATH)
	@eval "$$(${HOME}/.anyenv/bin/anyenv init -)" && 	\
	    $(GOENV_PATH)/bin/goenv install $* &&		\
	    $(GOENV_PATH)/bin/goenv global $*

goenv:				##@env Install goenv only, via anyenv.
goenv: $(GOENV_PATH)
$(GOENV_PATH): $(ANYENV_PATH) 
	$(HOME)/.anyenv/bin/anyenv install goenv

go:				##@languages Install Go (using goenv).
go: $(GOENV_PATH)/versions/$(GO_VER)

.PHONY: goenv go
