GIT := $(shell command -v git;)
ANYENV_PATH := ${HOME}/.anyenv

$(ANYENV_PATH):
ifdef GIT
	git clone -q https://github.com/riywo/anyenv $(ANYENV_PATH)
	mkdir -p $(ANYENV_PATH)/plugins
	git clone https://github.com/znz/anyenv-update.git $(ANYENV_PATH)/plugins/anyenv-update
	$(ANYENV_PATH)/bin/anyenv install --force-init
else
	$(warning anyenv requires git to be installed)
endif

anyenv:				##@env Install anyenv to manage **envs.
anyenv: $(ANYENV_PATH)

ifneq ($(wildcard $ANYENV_PATH/bin/anyenv),)
envs := $(strip $(shell $(ANYENV_PATH)/bin/anyenv install -l | awk '/^ / { print $1 }'))
$(addprefix $(ANYENV_PATH)/envs/,$(envs)): |$(ANYENV_PATH)
	eval "$$($(ANYENV_PATH)/bin/anyenv init -)" && \
	    $(ANYENV_PATH)/bin/anyenv install -s $(@F)
endif

showenvs:
	@echo "Discovered envs:"
	@echo $(envs)

.PHONY: anyenv showenvs
