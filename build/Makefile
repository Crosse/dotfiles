# Variables
UNAME := $(shell uname)

GO := $(shell command -v go;)

# From https://gist.github.com/prwhite/8168133#gistcomment-1727513
# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
	%help; \
	while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z0-9\-_]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
	print "usage: make [target]\n\n"; \
	for (sort keys %help) { \
	print "$$_:\n"; \
	for (@{$$help{$$_}}) { \
	$$sep = " " x (32 - length $$_->[0]); \
	print "  $$_->[0]$$sep$$_->[1]\n"; \
	}; \
	print "\n"; }


.PHONY: help
help:				##@other Show this help.
help:
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

.PHONY: default
default:			##@meta Install dotfiles and useful tools
default: dotfiles tools

.PHONY: all
all:				##@meta Install everything.
all: default $(UNAME) git go rust rust-nightly

.PHONY: dotgit
dotgit: $(HOME)/.local/bin/dotgit
$(HOME)/.local/bin/dotgit:
	python3 -m pip install --user -U dotgit

.PHONY: dotfiles
dotfiles:			## Symlink all dotfiles to $HOME.
dotfiles: dotgit
	cd .. && ${HOME}/.local/bin/dotgit restore -v

.PHONY: font-install
font-install: $(HOME)/code/go/bin/font-install
$(HOME)/code/go/bin/font-install: | go
	cd ~ && GO111MODULE=off $(GO) get github.com/Crosse/font-install

.PHONY: fonts
fonts:				## Installs fonts using font-install
fonts: $(CURDIR)/fontslist.txt | $(HOME)/code/go/bin/font-install
	$(HOME)/code/go/bin/font-install -fromFile "$<"

.PHONY: tools
tools:				## Personal and third-party tools I rely on.
	$(CURDIR)/tools/install.sh go ruby py2 py3


ifeq ($(UNAME),Darwin)
RUST_TRIPLE := $(shell uname -m)-apple-darwin
else ifeq ($(UNAME),Linux)
RUST_TRIPLE := $(shell uname -m)-unknown-linux-gnu
endif

.PHONY: rustup
rustup: $(HOME)/.cargo/bin/rustup
$(HOME)/.cargo/bin/rustup:
	@echo "==> Installing rustup"
	@curl https://sh.rustup.rs -sSf | sh -s -- --no-modify-path -y

.PHONY: rust
rust:				##@languages Install the latest stable Rust toolchain (uses rustup).
rust: $(HOME)/.rustup/toolchains/stable-$(RUST_TRIPLE)
$(HOME)/.rustup/toolchains/stable-$(RUST_TRIPLE): | $(HOME)/.cargo/bin/rustup
	@echo "==> Installing Rust stable"
	@rustup toolchain install stable
	@echo "==> Installing Rust components (rust-src, rust-analysis, Rust Language Server, rustfmt)"
	@rustup component add --toolchain stable rust-src rust-analysis rls rustfmt clippy

.PHONY: rust-nightly
rust-nightly:			##@languages Install the latest nightly Rust toolchain (uses rustup).
rust: $(HOME)/.rustup/toolchains/nightly-$(RUST_TRIPLE)
$(HOME)/.rustup/toolchains/nightly-$(RUST_TRIPLE): | $(HOME)/.cargo/bin/rustup
	@echo "==> Installing Rust nightly"
	@rustup toolchain install nightly
	@echo "==> Installing Rust components (rust-src)"
	@rustup component add --toolchain nightly rust-src

#include $(CURDIR)/vers.mk
#include $(CURDIR)/mk/help.mk
#include $(CURDIR)/mk/cross-platform.mk
#include $(CURDIR)/mk/anyenv.mk
#include $(CURDIR)/mk/go.mk
#include $(CURDIR)/mk/python.mk
#include $(CURDIR)/mk/ruby.mk

-include $(CURDIR)/mk/os/$(UNAME).mk
