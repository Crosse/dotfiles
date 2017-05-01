ANYENV_PATH := ${HOME}/.anyenv

$(ANYENV_PATH):
ifdef GIT
	git clone https://github.com/riywo/anyenv ${HOME}/.anyenv
else
	$(warning anyenv requires git to be installed)
endif

anyenv:				##@env Install anyenv to manage **envs.
anyenv: $(ANYENV_PATH)

.PHONY: anyenv
