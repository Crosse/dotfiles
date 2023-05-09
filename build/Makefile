# Variables
SHELL := bash
UNAME := $(shell uname)

GO := $(shell command -v go;)
GEM := $(shell command -v gem;)

default: help

build:			##@meta Run the bin, dotfiles, and keyservers targets.
build: bin dotfiles keyservers

all:				##@meta Run the default, fonts, and tools targets.
all: default fonts tools

bin:				## Symlink all bin files to $HOME/bin.
	@echo "==> Creating symlinks in ${HOME}/bin"
	@$(CURDIR)/symlink.sh


dotfiles:			## Symlink all dotfiles to $HOME.
	@echo "==> Symlinking dotfiles into ${HOME}"
	@$(CURDIR)/dotfiles.sh


fonts:				## Installs fonts using font-install
fonts:
	font-install -fromFile "$(CURDIR)/fontslist.txt"

tools:				## Personal and third-party tools I rely on.
	$(CURDIR)/tools/install.sh go ruby py3

vscode-ext:			## Visual Studio Code extensions
	$(CURDIR)/tools/install.sh vscode

misc: ## Miscellaneous things, like diff-so-fancy.
misc:
	@echo "==> Downloading diff-so-fancy"
	$(DOWNLOADER) $(DL_OPTS) https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy > "${HOME}/bin/diff-so-fancy"
	@chmod +x "${HOME}/bin/diff-so-fancy"
	@echo "==> Downloading Git completion for git version $(GIT_VERSION)"
	$(DOWNLOADER) $(DL_OPTS) https://raw.githubusercontent.com/git/git/v$(GIT_VERSION)/contrib/completion/git-completion.bash > "${HOME}/.bash_completion.d/git-completion.bash"


keyservers:			## Download the latest public certificate for sks-keyservers.
	@echo "==> Retrieving the latest sks-keyservers.net CA"
	$(DOWNLOADER) $(DL_OPTS) https://sks-keyservers.net/sks-keyservers.netCA.pem > "${HOME}/.gnupg/sks-keyservers.netCA.pem"


.PHONY: default build all bin dotfiles tools misc keyservers

include $(CURDIR)/vers.mk
include $(CURDIR)/mk/help.mk
include $(CURDIR)/mk/cross-platform.mk
include $(CURDIR)/mk/anyenv.mk
include $(CURDIR)/mk/go.mk
include $(CURDIR)/mk/python.mk
include $(CURDIR)/mk/ruby.mk
include $(CURDIR)/mk/rust.mk

-include $(CURDIR)/mk/os/$(UNAME).mk
