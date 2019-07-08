etc:				##@linux-specific Copy site-wide config files to /etc.
	@echo "==> Copying config files to /etc"
	sudo cp -Rv $(CURDIR)/../etc/* /etc

.PHONY: etc
