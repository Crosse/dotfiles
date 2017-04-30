# Variables
GOVER := 1.8
GOROOT ?= /usr/local/go
GOPATH ?= $(HOME)/code/go
export GOPATH

UNAME := $(shell uname)
ARCH := $(shell uname -m)

GEM := $(shell command -v gem;)
GIT := $(shell command -v git;)
GO := $(shell command -v go;)
FONT_INSTALL := $(shell command -v font-install;)


default: help

build:			##@meta Run the bin, dotfiles, personal, and keyservers targets.
build: bin dotfiles personal keyservers

all:				##@meta Run the default, fonts, go, gotools, and personal targets.
all: default fonts go gotools personal

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

bin:				## Symlink all bin files to $HOME/bin.
	@echo "==> Creating symlinks in ${HOME}/bin"
	@$(CURDIR)/symlink.sh

dotfiles:			## Symlink all dotfiles to $HOME
	@echo "==> Symlinking dotfiles into ${HOME}"
	@$(CURDIR)/dotfiles.sh

fonts:				## Install fonts using font-install.
fonts: $(GOROOT)
ifndef FONT_INSTALL
	@echo "==> Installing prerequisite: font-install"
	go get -u github.com/Crosse/font-install
endif
	@echo "==> Installing fonts"
	font-install -fromFile fontslist.txt

${HOME}/.anyenv:
ifdef GIT
	git clone https://github.com/riywo/anyenv ${HOME}/.anyenv
else
	$(warning anyenv requires git to be installed)
endif

anyenv:				## Install anyenv.
anyenv: ${HOME}/.anyenv

go:				##@go Install Go.
go: $(GOROOT)
$(GOROOT):
	@echo "==> Installing Go $(GOVER)"
	sudo $(CURDIR)/install_go.sh $(GOVER)
	mkdir -p $(GOPATH)

go-remove:			##@go Remove Go.
	@echo "==> Removing $(GOROOT)"
	sudo $(RM) -rf $(GOROOT)

go-update:			##@go Update Go to the the version specified in this Makefile.
go-update: go-remove go

gotools:			##@go Install some useful Go tools (golint, cover).
gotools: $(GOROOT)
	@echo "==> Installing Go tools"
	$(GO) get -u github.com/golang/lint/golint
	$(GO) get -u golang.org/x/tools/cmd/cover

personal:			## Install personal tools (sshsrv, font-install, pwhois).
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

python-tools: ##@python Install some useful Python tools (pyenv)
python-tools:
	$(DOWNLOADER) $(DL_OPTS) https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

keyservers:			## Download the latest public certificate for sks-keyservers.
	@echo "==> Retrieving the latest sks-keyservers.net CA"
	$(DOWNLOADER) $(DL_OPTS) https://sks-keyservers.net/sks-keyservers.netCA.pem > "${HOME}/.gnupg/sks-keyservers.netCA.pem"


.PHONY: default all info _info bin dotfiles fonts vim go go-remove gotools\
		personal python-tools keyservers

include mk/cross-platform.mk
include mk/$(UNAME).mk
