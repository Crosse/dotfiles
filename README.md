# dotfiles

These are my dotfiles.  There are many like them, but these ones are
mine.

## Installing/Updating

Use `make help` to get a list of things you can do.

```console
usage: make [target]

go:
  go                              Install Go.
  go-remove                       Remove Go.
  go-update                       Update Go to the the version specified in this Makefile.
  gotools                         Install some useful Go tools (golint, cover).

meta:
  build                           Run the bin, dotfiles, personal, and keyservers targets.
  all                             Run the default, fonts, go, gotools, and personal targets.
  mac                             Run the all and pkgsrc targets.

options:
  bin                             Symlink all bin files to $HOME/bin.
  dotfiles                        Symlink all dotfiles to $HOME
  fonts                           Install fonts using font-install.
  anyenv                          Install anyenv.
  personal                        Install personal tools (sshsrv, font-install, pwhois).
  keyservers                      Download the latest public certificate for sks-keyservers.

other:
  info                            Print out environment as detected by this Makefile.
  help                            Show this help.

pkgsrc:
  pkgsrc                          Install pkgsrc.
  pkgsrc-remove                   Remove pkgsrc.
  git                             Install git from pkgsrc.
```

## Attribution
The Makefile and symlinking ideas were borrowed from the most-excellent
[Jessie Frazelle's](https://twitter.com/frazelledazzell)
[dotfiles repo](https://github.com/jfrazelle/dotfiles).
