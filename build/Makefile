# Variables
UNAME := $(shell uname)

GO := $(shell command -v go;)
GEM := $(shell command -v gem;)

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


tools:				## Personal and third-part tools I rely on.
	$(CURDIR)/tools/install.sh go ruby py2 py3

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

include vers.mk
include mk/help.mk
include mk/cross-platform.mk
include mk/anyenv.mk
include mk/go.mk
include mk/python.mk
include mk/ruby.mk
include mk/rust.mk

-include mk/os/$(UNAME).mk
