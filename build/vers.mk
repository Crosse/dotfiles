GO_VER := 1.9
PY2_VER := 2.7.14
PY3_VER := 3.6.2
RUBY_VER := 2.4.2

versions:		##@other Show software versions that will be installed.
	@printf "Versions of software that will be installed:\n"
	@printf "Go:\t\t$(GO_VER)\n"
	@printf "Python 2:\t$(PY2_VER)\n"
	@printf "Python 3:\t$(PY3_VER)\n"
	@printf "Ruby:\t\t$(RUBY_VER)\n"
	@printf "\nUpdate these versions in vers.mk, if necessary.\n"
