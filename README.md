# dotfiles

These are my dotfiles.  There are many like them, but these ones are
mine.

## Installing/Updating

```
$ cd dotfiles/build
$ make <target>
```

where `<target>` can be one of:

* `bin`: create $HOME/bin and symlink bin/\* into it.
* `dotfiles`: symlink dotfiles into $HOME
* `etc`: copy files from etc/ to /etc
* `fonts`: download fonts for fontconfig to use and install them at
  `$XDG_DATA_HOME/fonts`
* `install_git`: install git from pkgsrc. Not useful unless you're using
  pkgsrc.
* `install_go`: install Go. See `GOVER` in the
  [Makefile](build/Makefile) for which version will be installed
* `install_gotools`: instal some useful go tools.
* `install_personal`: install some personal projects.
* `install_pkgsrc`: install pkgsrc. Useful on a Mac.
* `install_rkt`: install rkt. See `RKTVER` in the
  [Makefile](build/Makefile) for which version will be installed

That's a lot. Here are some metatargets.
* `default`: run the `bin` and `dotfiles` targets.
* `all`: run the `default`, `fonts`, `install_go`, `install_gotools`, and `install_personal` targets.
* `mac`: runs the `all` and `install_pkgsrc` targets.

(This sucks and I know it, but it works and I have better things to do.)

## Attribution
The Makefile and symlinking ideas were borrowed from the most-excellent
[Jessie Frazelle's](https://twitter.com/frazelledazzell)
[dotfiles repo](https://github.com/jfrazelle/dotfiles).
