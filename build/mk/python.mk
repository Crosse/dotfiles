PYENV_PATH := $(ANYENV_PATH)/envs/pyenv

$(PYENV_PATH): $(ANYENV_PATH)
	eval "$$(${HOME}/.anyenv/bin/anyenv init -)" && \
	    ${HOME}/.anyenv/bin/anyenv install -s pyenv

$(PYENV_PATH)/versions/$(PY2_VER):
	eval "$$(${HOME}/.anyenv/bin/anyenv init -)" && \
	    $(PYENV_PATH)/bin/pyenv install -s $(PY2_VER)

$(PYENV_PATH)/versions/$(PY3_VER):
	eval "$$(${HOME}/.anyenv/bin/anyenv init -)" && \
	    $(PYENV_PATH)/bin/pyenv install -s $(PY3_VER)


pyenv:			##@env Install pyenv via anyenv
pyenv: $(PYENV_PATH)

python27:	##@languages Install Python 2.7 (uses pyenv)
python27: $(PYENV_PATH)/versions/$(PY2_VER)

python36:	##@languages Install Python 3.6 (uses pyenv)
python36: $(PYENV_PATH)/versions/$(PY3_VER)

.PHONY: pyenv python27 python36
