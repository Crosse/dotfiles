# Variables
RKTVER := v1.18.0
GOVER := 1.7.3
GOROOT ?= /usr/local/go
GOPATH ?= $(HOME)/code/go

GO := $(GOROOT)/bin/go
export GOPATH
GIT := $(shell command -v git;)
UNAME := $(shell uname)
ARCH := $(shell uname -m)

default: bin dotfiles
all: default fonts install_go install_gotools install_personal
mac: all install_pkgsrc

bin:
	@echo "==> Creating symlinks in ${HOME}/bin"
	@$(CURDIR)/symlink.sh

dotfiles:
	@echo "==> Symlinking dotfiles into ${HOME}"
	@$(CURDIR)/dotfiles.sh

etc:
	@echo "==> Copying config files to /etc"
	@sudo cp -Rv $(CURDIR)/../etc/* /etc

fonts:
	@echo "==> Downloading font files"
	@$(CURDIR)/fonts.sh

install_go: $(GOROOT)
$(GOROOT):
	@echo "Installing Go $(GOVER)"
	sudo $(CURDIR)/install_go.sh $(GOVER)

install_rkt:
	@echo "Installing rkt $(RKTVER)"
	sudo $(CURDIR)/install_rkt.sh $(RKTVER)

clean_go:
	@echo "==> Removing $(GOROOT)"
	sudo $(RM) -rf $(GOROOT);		\

install_gotools: $(GOROOT)
	@echo "==> Installing Go tools"
	$(GO) get -u github.com/golang/lint/golint
	$(GO) get -u golang.org/x/tools/cmd/cover

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

.PHONY: default all bin dotfiles vim		\
	install_go clean_go install_gotools 		\
	install_personal install_pkgsrc			\
	clean_pkgsrc git install_git
