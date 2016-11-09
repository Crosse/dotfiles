# Variables
GOVER := 1.7.3
GOROOT ?= /usr/local/go
GOPATH ?= $(HOME)/code/go
export GOPATH

UNAME := $(shell uname)
ARCH := $(shell uname -m)

GEM := $(shell command -v gem;)
GIT := $(shell command -v git;)
GO := $(shell command -v go;)
FONT_INSTALL := $(shell command -v font-install;)


default: bin dotfiles install_personal
all: default fonts install_go install_gotools install_personal
mac: all install_pkgsrc
info: _info $(UNAME)_info

_info:
	$(info Detected platform: $(UNAME))
	$(info Using $(DOWNLOADER) to download files)
ifdef GO
	$(info Found Go at $(GO))
endif
ifdef GIT
	$(info Found Git at $(GIT))
endif
ifdef FONT_INSTALL
	$(info Found font-install at $(FONT_INSTALL))
endif

bin:
	@echo "==> Creating symlinks in ${HOME}/bin"
	@$(CURDIR)/symlink.sh

dotfiles:
	@echo "==> Symlinking dotfiles into ${HOME}"
	@$(CURDIR)/dotfiles.sh

fonts: $(GOROOT)
ifndef FONT_INSTALL
	@echo "==> Installing prerequisite: font-install"
	go get -u github.com/Crosse/font-install
endif
	@echo "==> Installing fonts"
	font-install -fromFile fontslist.txt

install_go: $(GOROOT)
$(GOROOT):
	@echo "==> Installing Go $(GOVER)"
	sudo $(CURDIR)/install_go.sh $(GOVER)
	mkdir -p $(GOPATH)

clean_go:
	@echo "==> Removing $(GOROOT)"
	sudo $(RM) -rf $(GOROOT)

install_gotools: $(GOROOT)
	@echo "==> Installing Go tools"
	$(GO) get -u github.com/golang/lint/golint
	$(GO) get -u golang.org/x/tools/cmd/cover

install_personal:
	@echo "==> Installing personal tools"
ifdef GO
	go get -u github.com/Crosse/sshsrv
	go get -u github.com/Crosse/font-install
else
	$(warning Some tools require Go, which is not currently installed.)
endif
ifdef  GEM
	sudo gem install pwhois
else
	$(warning Some tools require Go, which is not currently installed.)
endif

.PHONY: default all bin dotfiles vim		\
	install_go clean_go install_gotools 	\
	install_personal info _info

include mk/cross-platform.mk
include mk/$(UNAME).mk
