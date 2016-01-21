# Variables
GOVER := 1.5.3
GOROOT ?= /usr/local/go
GOPATH ?= $(HOME)/code/go
SCMURI := git@github.com:Crosse

GO := $(GOROOT)/bin/go
export GOPATH
GIT := $(shell command -v git;)
UNAME := $(shell uname)
ARCH := $(shell uname -m)

default: bin dotfiles
all: default fonts install_go install_gotools install_personal install_pkgsrc vim

bootstrap: git
	@echo "==> Cloning dotfiles into $(CURDIR)/dotfiles"
	@git clone $(SCMURI)/dotfiles.git $(CURDIR)/dotfiles
	@cd $(CURDIR)/dotfiles/build && $(MAKE) all

bin:
	@echo "==> Creating symlinks in ${HOME}/bin"
	@$(CURDIR)/symlink.sh

dotfiles:
	@echo "==> Symlinking dotfiles into ${HOME}"
	@$(CURDIR)/dotfiles.sh

etc:
	@echo "==> Copying config files to /etc"
	@cp -Rv $(CURDIR)/../etc/* /etc

fonts:
	@echo "==> Downloading font files"
	@$(CURDIR)/fonts.sh

vim: git
	@echo "==> Cloning vimfiles into ${HOME}/.vim"
	git clone $(SCMURI)/vimfiles.git $(HOME)/.vim
	@cd $(HOME)/.vim && $(MAKE) install

install_go: $(GOROOT)
$(GOROOT):
	@echo "Installing Go $(GOVER)"
	sudo $(CURDIR)/install_go.sh $(GOVER)

clean_go:
	@echo "==> Removing $(GOROOT)"
	sudo $(RM) -rf $(GOROOT);		\

install_gotools: $(GOROOT)
	@echo "==> Installing Go tools"
	$(GO) get -u github.com/golang/lint/golint
	$(GO) get -u golang.org/x/tools/cmd/cover
	$(GO) get -u golang.org/x/tools/cmd/vet

install_personal:
	@echo "==> Installing personal tools"
	go get -u github.com/crosse/sshsrv
	@if [ -n "$(shell command -v gem;)" ]; then	\
		sudo gem install pwhois;		\
	fi

install_pkgsrc: /opt/pkg
/opt/pkg:
ifeq ($(UNAME),$(filter $(UNAME),Darwin SmartOS))
	@echo "==> Installing pkgsrc"
	@$(CURDIR)/install_pkgsrc.sh
else
	$(info pkgsrc not needed on this platform)
endif

clean_pkgsrc:
	@echo "==> Removing pkgsrc"
	sudo $(RM) -rf /opt/pkg /var/db/pkgin

install_git:
	@$(MAKE) install_pkgsrc
	sudo pkgin -y in git

git:
ifndef GIT
	$(warning Git is not installed, or not in PATH)
	$(MAKE) install_git
endif

.PHONY: default all bootstrap bin dotfiles vim		\
	install_go clean_go install_gotools 		\
	install_personal install_pkgsrc			\
	clean_pkgsrc git install_git
