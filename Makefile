.PHONY: update submodules bin dotfiles remove_go install_go
all: update submodules bin dotfiles install_go install_gotools

update:
	@echo "==> Updating local repo"
	@git pull --rebase


submodules:
	@echo "==> Updating submodules"
	@git submodule update --init --recursive


ycm:
	@echo "==> Building YouCompleteMe"
	@$(CURDIR)/.vim/bundle/YouCompleteMe/install.py	\
			--clang-completer		\
			--gocode-completer		\
			--omnisharp-completer


bin:
	@echo "==> Creating symlinks in $(HOME)/bin"
	@for file in $(shell find "$(CURDIR)/bin"	\
				-mindepth 1		\
				-not -name '.*.swp'	\
			); do				\
		f=$$(basename $$file);			\
		ln -sfn "$$file" "${HOME}/bin/$$f";	\
	done


dotfiles:
	@echo "==> Symlinking dotfiles into $(HOME)"
	@for file in $(shell find "$(CURDIR)"		\
				-mindepth 1 -maxdepth 1	\
				-not -name 'Makefile'	\
				-not -name 'README.md'	\
				-not -name 'bin'	\
				-not -name 'per-os'	\
				-not -name '.gitignore'	\
				-not -name '.gitmodules'\
				-not -name '.git'	\
				-not -name '.*.swp'	\
			); do				\
		f=$$(basename $$file);			\
		ln -sfn "$$file" "$(HOME)/$$f";		\
	done


GO_VERSION := 1.5.1
UNAME := $(shell uname)
ARCH := $(shell uname -m)

GOFILE = go$(GO_VERSION)
ifeq ($(UNAME),Linux)
	GOFILE := $(GOFILE).linux
else ifeq ($(UNAME),Darwin)
	GOFILE := $(GOFILE).darwin
else
	@echo "Platform isn't Linux or Darwin"
	exit
endif

ifeq ($(ARCH),x86_64)
	GOFILE := $(GOFILE)-amd64.tar.gz
else ifeq ($(ARCH),i386)
	GOFILE := $(GOFILE)-386.tar.gz
else
	@echo "Arch isn't x86_64 or i386"
	exit
endif

GO_URI := https://storage.googleapis.com/golang/$(GOFILE)
WGET := $(shell command -v wget)
CURL := $(shell command -v curl)

ifdef WGET
	DLCMD := $(WGET) -O-
else ifdef CURL
	DLCMD := $(CURL) -L
else
	@echo "Neither curl nor wget are installed"
	exit
endif

remove_go:
	@if [ -d /usr/local/go ]; then 		\
		echo ==> Removing Go install;	\
		sudo $(RM) -rf /usr/local/go;	\
	fi

install_go: /usr/local/go

/usr/local/go:
	@echo "==> Downloading Go $(GO_VERSION)"
	@sudo -v
	@$(DLCMD) $(GO_URI) | sudo tar xzf - -C /usr/local

install_gotools: /usr/local/go
	go get -u github.com/golang/lint/golint
	go get -u golang.org/x/tools/cmd/cover
	go get -u golang.org/x/tools/cmd/vet
