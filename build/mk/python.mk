PYENV_PATH := $(ANYENV_PATH)/envs/pyenv

pyenv:			##@env Install pyenv via anyenv.
pyenv: $(PYENV_PATH) pyenv-virtualenv
$(PYENV_PATH): $(ANYENV_PATH)
	$(HOME)/.anyenv/bin/anyenv install pyenv

pyenv-virtualenv: $(PYENV_PATH)/plugins/pyenv-virtualenv
$(PYENV_PATH)/plugins/pyenv-virtualenv: $(PYENV_PATH)
	eval "$$(${HOME}/.anyenv/bin/anyenv init -)" && \
	    git clone https://github.com/pyenv/pyenv-virtualenv.git $@

$(PYENV_PATH)/versions/%: $(PYENV_PATH)
	eval "$$(${HOME}/.anyenv/bin/anyenv init -)" && \
	    $(PYENV_PATH)/bin/pyenv install -s $*

python2:	##@languages Install Python 2 (uses pyenv).
python2: $(PYENV_PATH)/versions/$(PY2_VER) pyenv-virtualenv
	@pyenv rehash
	@echo Updating pip..
	@$(PYENV_PATH)/versions/$(PY2_VER)/bin/pip install --upgrade pip
	@echo Installing useful modules...
	@$(PYENV_PATH)/versions/$(PY2_VER)/bin/pip install readline

python3:	##@languages Install Python 3 (uses pyenv).
python3: $(PYENV_PATH)/versions/$(PY3_VER) pyenv-virtualenv
	@pyenv rehash
	@echo Updating pip3..
	@$(PYENV_PATH)/versions/$(PY3_VER)/bin/pip install --upgrade pip
	@echo Installing useful modules...
	@$(PYENV_PATH)/versions/$(PY3_VER)/bin/pip install readline

python:		##@languages Install Python 2 and 3 (uses pyenv).
python: python2 python3
	@echo "Setting global Python versions to $(PY2_VER) and $(PY3_VER)"
	@pyenv global $(PY2_VER) $(PY3_VER)

.PHONY: pyenv pyenv-virtualenv python2 python3 python
