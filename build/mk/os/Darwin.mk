Darwin: pkgsrc

pkgsrc:			##@platform-specific (macOS) Install pkgsrc.
pkgsrc: /opt/pkg
/opt/pkg:
	@echo "==> Installing pkgsrc"
	@$(CURDIR)/install_pkgsrc.sh

git:			##@platform-specific (macOS) Install git from pkgsrc.
git: /opt/pkg/bin/git
/opt/pkg/bin/git: | pkgsrc
	sudo pkgin -y in git

go:			##@platform-specific (macOS) Install Go from pkgsrc.
go: /opt/pkg/bin/go
/opt/pkg/bin/go: | pkgsrc
	sudo pkgin -y in go


.PHONY: pkgsrc git go
