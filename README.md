# dotfiles

These are my dotfiles.  There are many like them, but these ones are
mine.

## Installing/Updating

Just run

```
make
```

and call it a day.  This will
* update the repo,
* initialize and update all submodules (so far just Vim plugins),
* symlink bin/* to ${HOME}/bin/, and
* symlink .* to ${HOME}/

There's another `make` target to recompile YouCompleteMe because I'm
that lazy.


## Attribution
The Makefile and symlinking ideas were borrowed from the most-excellent
[Jessie Frazelle's](https://twitter.com/frazelledazzell)
[dotfiles repo](https://github.com/jfrazelle/dotfiles).


## License
*Because it's better to be explicit, I guess...*

    Copyright (c) 2015, Seth Wright <seth@crosse.org>

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
