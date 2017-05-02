RBENV_PATH := $(ANYENV_PATH)/envs/rbenv

rbenv:			##@env Install rbenv via anyenv.
rbenv: $(RBENV_PATH)

ruby:			##@languages Install Ruby (uses rbenv).
ruby: |$(RBENV_PATH)/versions/$(RUBY_VER)

$(RBENV_PATH)/versions/%: |$(RBENV_PATH)
	eval "$$(${HOME}/.anyenv/bin/anyenv init -)" && \
	    $(RBENV_PATH)/bin/rbenv install -s &*

.PHONY: rbenv ruby
