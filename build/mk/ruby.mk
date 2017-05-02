RBENV_PATH := $(ANYENV_PATH)/envs/rbenv

rbenv:			##@env Install rbenv via anyenv.
rbenv: $(RBENV_PATH)

ruby:			##@languages Install Ruby (uses rbenv).
ruby: $(RBENV_PATH)
	eval "$$(${HOME}/.anyenv/bin/anyenv init -)" && \
	    $(RBENV_PATH)/bin/rbenv install -s $(RUBY_VER)

.PHONY: rbenv ruby
