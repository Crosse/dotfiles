Darwin_info:
	$(info Detected OSX $(shell sw_vers -productVersion))

install_pkgsrc: /opt/pkg
/opt/pkg:
	@echo "==> Installing pkgsrc"
	@$(CURDIR)/install_pkgsrc.sh

clean_pkgsrc:
	@echo "==> Removing pkgsrc"
	sudo $(RM) -rf /opt/pkg /var/db/pkgin

install_git:
	@$(MAKE) install_pkgsrc
	sudo pkgin -y in git


.PHONY: Darwin_info install_pkgsrc clean_pkgsrc install_git
