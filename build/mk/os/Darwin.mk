Darwin_info:
	$(info Detected OSX $(shell sw_vers -productVersion))

/opt/pkg:
	@echo "==> Installing pkgsrc"
	@$(CURDIR)/install_pkgsrc.sh

pkgsrc:			##@platform-specific (OSX) Install pkgsrc.
pkgsrc: /opt/pkg

pkgsrc-remove:		##@platform-specific (OSX) Remove pkgsrc.
	@echo "==> Removing pkgsrc"
	sudo $(RM) -rf /opt/pkg /var/db/pkgin

git:			##@platform-specific (OSX) Install git from pkgsrc.
git: /opt/pkg/bin/git

/opt/pkg/bin/git: /opt/pkg
	sudo pkgin -y in git


.PHONY: Darwin_info pkgsrc pkgsrc-remove git
