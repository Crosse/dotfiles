RKTVER := v1.18.0
ACBUILDVER := v0.2.2

RKT := $(shell command -v rkt;)
ACBUILD := $(shell command -v acbuild;)

Linux_info:
ifdef RKT
	$(info Found rkt at $(RKT))
endif

etc:
	@echo "==> Copying config files to /etc"
	sudo cp -Rv $(CURDIR)/../etc/* /etc

install_rkt:
ifndef RKT
	@echo "==> Installing rkt $(RKTVER)"
	sudo $(CURDIR)/install_rkt.sh $(RKTVER)
endif
ifndef ACBUILD
	@echo "==> Installing acbuild $(ACBUILDVER)"
	$(DOWNLOADER) $(DL_OPTS) "https://github.com/appc/acbuild/releases/download/$(ACBUILDVER)/acbuild.tar.gz" | tar xzf - -C /usr/local/bin
endif

.PHONY: Linux_info etc install_rkt
