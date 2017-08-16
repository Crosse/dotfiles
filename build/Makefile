# Variables
UNAME := $(shell uname)

GO := $(shell command -v go;)
GEM := $(shell command -v gem;)
FONT_INSTALL := $(shell command -v font-install;)

default: help

build:			##@meta Run the bin, dotfiles, personal, and keyservers targets.
build: bin dotfiles personal keyservers

all:				##@meta Run the default, fonts, go, gotools, and personal targets.
all: default fonts personal

bin:				## Symlink all bin files to $HOME/bin.
	@echo "==> Creating symlinks in ${HOME}/bin"
	@$(CURDIR)/symlink.sh

dotfiles:			## Symlink all dotfiles to $HOME.
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

personal:			## Install personal tools (sshsrv, font-install, pwhois).
	@echo "==> Installing personal tools"
ifdef GO
	go get -u github.com/Crosse/sshsrv
	go get -u github.com/Crosse/font-install
else
	$(warning Some tools require Go, which is not currently installed.)
endif
ifdef  GEM
	gem install pwhois
	gem install neovim
else
	$(warning Some tools require Ruby, which is not currently installed.)
endif

misc: ## Miscellaneous things, like diff-so-fancy.
misc:
	$(DOWNLOADER) $(DL_OPTS) https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy > "${HOME}/bin/diff-so-fancy"
	chmod +x "${HOME}/bin/diff-so-fancy"

keyservers:			## Download the latest public certificate for sks-keyservers.
	@echo "==> Retrieving the latest sks-keyservers.net CA"
	$(DOWNLOADER) $(DL_OPTS) https://sks-keyservers.net/sks-keyservers.netCA.pem > "${HOME}/.gnupg/sks-keyservers.netCA.pem"


.PHONY: default build all bin dotfiles fonts personal misc keyservers

include vers.mk
include mk/help.mk
include mk/cross-platform.mk
include mk/anyenv.mk
include mk/go.mk
include mk/python.mk
include mk/ruby.mk

include mk/os/$(UNAME).mk
