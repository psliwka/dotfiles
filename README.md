My public dotfiles
==================

This repository holds some of my dotfiles, which I deemed useful enough to be
worth publishing.

Tested on Debian Sid and Mac OS X. Synchronized using
[homeshick](https://github.com/andsens/homeshick).

How to quickly infect a new machine
-----------------------------------

```sh
git clone https://github.com/andsens/homeshick.git ~/.homesick/repos/homeshick
~/.homesick/repos/homeshick/bin/homeshick clone psliwka/dotfiles
exec bash -l
```

License
-------

Copyright 2018-$(date +%Y) [Piotr Śliwka](https://github.com/psliwka). Licensed
as [WTFPL](COPYING).
