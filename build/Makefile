default: bin dotfiles
go: install_go install_gotools
install: default go install_personal install_pkgsrc vim

bootstrap:
	@echo "==> Cloning dotfiles into $(CURDIR)/dotfiles"
	@git clone git@github.com:Crosse/dotfiles.git $(CURDIR)/dotfiles
	@cd $(CURDIR)/build/dotfiles && $(MAKE) install

bin:
	$(CURDIR)/build/symlink.sh

dotfiles:
	$(CURDIR)/build/dotfiles.sh

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
