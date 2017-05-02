PYENV_PATH := $(ANYENV_PATH)/envs/pyenv

pyenv:			##@env Install pyenv via anyenv.
pyenv: $(PYENV_PATH)

$(PYENV_PATH)/versions/%: $(PYENV_PATH)
	eval "$$(${HOME}/.anyenv/bin/anyenv init -)" && \
	    $(PYENV_PATH)/bin/pyenv install -s $*

python2:	##@languages Install Python 2 (uses pyenv).
python2: $(PYENV_PATH)/versions/$(PY2_VER)

python3:	##@languages Install Python 3 (uses pyenv).
python3: $(PYENV_PATH)/versions/$(PY3_VER)

.PHONY: pyenv python27 python36
