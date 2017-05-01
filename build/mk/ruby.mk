RBENV_PATH := $(ANYENV_PATH)/envs/rbenv

$(RBENV_PATH): $(ANYENV_PATH)
	eval "$$(${HOME}/.anyenv/bin/anyenv init -)" && \
	    anyenv install -s rbenv
rbenv:			##@env Install rbenv via anyenv
rbenv: $(RBENV_PATH)

ruby:	##@languages Install Ruby 2.3.1 (uses pyenv)
ruby: rbenv
	eval "$$(${HOME}/.anyenv/bin/anyenv init -)" && \
	    $(RBENV_PATH)/bin/rbenv install -s $(RUBY_VER)

.PHONY: rbenv ruby
