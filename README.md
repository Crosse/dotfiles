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
* `install_go`: install Go. See `GOVER` in the [Makefile](Makefile) for
  which version will be installed
* `install_gotools`: instal some useful go tools.
* `install_personal`: install some personal projects.
* `install_pkgsrc`: install pkgsrc. Useful on a Mac.
* `install_rkt`: install rkt. See `RKTVER` in the [Makefile](Makefile)
  for which version will be installed

That's a lot. Here are some metatargets.
* `default`: run the `bin` and `dotfiles` targets.
* `all`: run the `default`, `fonts`, `install_go`, `install_gotools`, and `install_personal` targets.
* `mac`: runs the `all` and `install_pkgsrc` targets.

(This sucks and I know it, but it works and I have better things to do.)

## Attribution
The Makefile and symlinking ideas were borrowed from the most-excellent
[Jessie Frazelle's](https://twitter.com/frazelledazzell)
[dotfiles repo](https://github.com/jfrazelle/dotfiles).


## License
    Copyright (c) 2015-2016, Seth Wright <seth@crosse.org>

    Permission to use, copy, modify, and/or distribute this software for
    any purpose with or without fee is hereby granted, provided that the
    above copyright notice and this permission notice appear in all
    copies.

    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
    WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
    WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
    AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL
    DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA
    OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER
    TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
    PERFORMANCE OF THIS SOFTWARE.
