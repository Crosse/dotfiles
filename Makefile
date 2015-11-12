GO_VERSION := 1.5.1
GO_SRC := /usr/local/go

all: update submodules bin dotfiles

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

install_go:
	@echo ==> Downloading Go $(GO_VERSION)


.PHONY: submodules bin dotfiles
