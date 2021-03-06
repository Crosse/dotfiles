# dotfiles

These are my dotfiles.  There are many like them, but these ones are
mine.

## Dependency on `anyenv`
I have made the decision to use [`anyenv`](https://github.com/riywo/anyenv)
to manage various programming language installations instead of attempting
to install them via a platform's package repository or downloading the pacakge
myself. Thus, installing Python, Ruby, or Go will first install `anyenv`, then
[`pyenv`](https://github.com/pyenv/pyenv) (and
[`pyenv-virtualenv`](https://github.com/pyenv/pyenv-virtualenv)),
[`rbenv`](https://github.com/rbenv/rbenv), and
[`goenv`](https://github.com/kaneshin/goenv), respectively.

## Installing/Updating

Use `make help` to get a list of things you can do.

```console
usage: make [target]

env:
  anyenv                          Install anyenv to manage **envs.
  goenv                           Install goenv via anyenv.
  pyenv                           Install pyenv via anyenv.
  rbenv                           Install rbenv via anyenv.

languages:
  go                              Install Go (using goenv).
  go-tools                        Install some useful Go tools (golint, cover).
  python2                         Install Python 2 (uses pyenv).
  python3                         Install Python 3 (uses pyenv).
  ruby                            Install Ruby (uses rbenv).

meta:
  build                           Run the bin, dotfiles, personal, and keyservers targets.
  all                             Run the default, fonts, go, gotools, and personal targets.

options:
  bin                             Symlink all bin files to $HOME/bin.
  dotfiles                        Symlink all dotfiles to $HOME.
  fonts                           Install fonts using font-install.
  personal                        Install personal tools (sshsrv, font-install, pwhois).
  misc                            Miscellaneous things, like diff-so-fancy.
  keyservers                      Download the latest public certificate for sks-keyservers.

other:
  versions                        Show software versions that will be installed.
  help                            Show this help.
  info                            Print out environment as detected by this Makefile.

platform-specific:
  pkgsrc                          (OSX) Install pkgsrc.
  pkgsrc-remove                   (OSX) Remove pkgsrc.
  git                             (OSX) Install git from pkgsrc.
```


## Attribution
The Makefile and symlinking ideas were borrowed from the most-excellent
[Jessie Frazelle's](https://twitter.com/jessfraz)
[dotfiles repo](https://github.com/jfrazelle/dotfiles).
The rest of the heinous `make` stuff is my own.
