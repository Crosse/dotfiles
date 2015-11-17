default: bin dotfiles
go: install_go install_gotools
install: default go install_personal install_pkgsrc vim

bootstrap:
	@echo "==> Cloning dotfiles into $(CURDIR)/dotfiles"
	@git clone git@github.com/crosse/dotfiles.git $(CURDIR)/dotfiles
	@cd $(CURDIR)/dotfiles && $(MAKE) install

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

vim:
	@git clone git@github.com/crosse/vimfiles.git $(HOME)/.vim
	@cd $(HOME)/.vim && $(MAKE) install

install_go: /usr/local/go

/usr/local/go:
	@sudo $(CURDIR)/build/install_go.sh

clean_go:
	@if [ -d /usr/local/go ]; then 			\
		@echo "==> Removing /usr/local/go";	\
		sudo $(RM) -rf /usr/local/go;		\
	else						\
		echo "Go is not installed";		\
	fi

install_gotools: /usr/local/go
	go get -u github.com/golang/lint/golint
	go get -u golang.org/x/tools/cmd/cover
	go get -u golang.org/x/tools/cmd/vet

install_personal:
	go get -u github.com/crosse/sshsrv
	@if [ -n "$(shell command -v gem)" ]; then		\
		sudo gem install pwhois;			\
	fi

install_pkgsrc: /opt/pkg
	@$(CURDIR)/build/install_pkgsrc.sh

clean_pkgsrc:
	$(RM) -f /opt/pkg /var/db/pkgin

clean_all: clean_go clean_pkgsrc

.PHONY: default bin dotfiles go install_go install_gotools 	\
    	install default install_personal vim clean_go		\
	install_pkgsrc clean_pkgsrc clean_all bootstrap
