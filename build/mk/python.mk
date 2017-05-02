PYENV_PATH := $(ANYENV_PATH)/envs/pyenv

pyenv:			##@env Install pyenv via anyenv.
pyenv: |$(PYENV_PATH) pyenv-virtualenv

pyenv-virtualenv: $(PYENV_PATH)/plugins/pyenv-virtualenv
$(PYENV_PATH)/plugins/pyenv-virtualenv: |$(PYENV_PATH)
	eval "$$(${HOME}/.anyenv/bin/anyenv init -)" && \
	    git clone https://github.com/pyenv/pyenv-virtualenv.git $(shell pyenv root)/plugins/pyenv-virtualenv

$(PYENV_PATH)/versions/%: |$(PYENV_PATH)
	eval "$$(${HOME}/.anyenv/bin/anyenv init -)" && \
	    $(PYENV_PATH)/bin/pyenv install -s $*

python2:	##@languages Install Python 2 (uses pyenv).
python2: $(PYENV_PATH)/versions/$(PY2_VER) pyenv-virtualenv

python3:	##@languages Install Python 3 (uses pyenv).
python3: $(PYENV_PATH)/versions/$(PY3_VER) pyenv-virtualenv

python:		##@languages Install Python 2 and 3 (uses pyenv).
python: python2 python3

.PHONY: pyenv python27 python36 python
