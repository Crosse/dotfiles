Darwin_info:
	$(info Detected OSX $(shell sw_vers -productVersion))

mac:				##@meta Run the all and pkgsrc targets.
mac: all pkgsrc

pkgsrc:		##@pkgsrc Install pkgsrc.
pkgsrc: /opt/pkg
/opt/pkg:
	@echo "==> Installing pkgsrc"
	@$(CURDIR)/install_pkgsrc.sh

pkgsrc-remove:		##@pkgsrc Remove pkgsrc.
	@echo "==> Removing pkgsrc"
	sudo $(RM) -rf /opt/pkg /var/db/pkgin

git:		##@pkgsrc Install git from pkgsrc.
	@$(MAKE) install_pkgsrc
	sudo pkgin -y in git


.PHONY: Darwin_info pkgsrc pkgsrc-remove git-install
