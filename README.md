
[//]: # (This file is generated, modify doc/readme.adoc and regenerate it with 'make update-doc')

![<https://github.com/jfgiraud/quote-and-join/actions>](https://img.shields.io/github/actions/workflow/status/jfgiraud/quote-and-join/main.yml?label=CI)

Description
===========

Small utilities to:

-   quote and join words or lines in files

-   split and unquote words in files

Installation
============

The destination directory will contain 3 sub-directories: `bin`, `share`
and `man`.

**Using git repo.**

    $ git clone https://github.com/jfgiraud/quote-and-join.git
    $ cd quote-and-join
    $ sudo make install DESTDIR=/usr/local

**Using latest tarball release.**

    $ curl -s -L https://api.github.com/repos/jfgiraud/quote-and-join/releases/latest | grep browser_download_url | cut -d':' -f2- | tr -d ' ",' | xargs wget -O quote-and-join.tgz
    $ sudo tar zxvf quote-and-join.tgz -C /usr/local

Usages
======

**Use man.**

    $ man qaj
    $ man uqaj

**Use option.**

    $ qaj -h
    $ uqaj -h

TLDR qaj
========

**Quote words with `'` and join with `,`.**

    $ echo lorem ipsum dolores est | qaj -w -q -j,
    'lorem','ipsum','dolores','est'

**Quote words with `"` and join with `, ` (comma + space).**

    $ echo lorem ipsum dolores est | qaj -w -qq -j', '
    "lorem", "ipsum", "dolores", "est"

**Prefix words with `<`, suffix words with `>` and join with `#`.**

    $ echo lorem ipsum dolores est | qaj -w -a'<' -b'>' -j#
    <lorem>#<ipsum>#<dolores>#<est>

**Extract words.**

    $ echo lorem ipsum dolores est | qaj -w
    lorem
    ipsum
    dolores
    est

**Prefix words with `<`, suffix words with the associated parenthese `>`
and join with `#`.**

    $ echo lorem ipsum dolores est | qaj -w -p'<' -j#
    <lorem>#<ipsum>#<dolores>#<est>

**Quote lines with `"` and join with `,`. Lines are trimmed..**

    $ printf "lorem\nipsum\n dolores\n\nest" | qaj -qq -j,
    "lorem","ipsum","dolores","est"

**Quote lines with `"` and join with `,`. Lines are not trimmed..**

    $ printf "lorem\nipsum\n dolores\n\nest" | qaj -qq -J -t
    "lorem", "ipsum", " dolores", "est"

**Quote lines with `"` and join with `,`. Lines are trimmed. Add a
prefix and suffix on the final result..**

    $ printf "lorem\nipsum\n dolores\n\nest" | qaj -qq -j, -A 'Final result: ' -B '.'
    Final result: "lorem","ipsum","dolores","est".

TLDR uqaj
=========

**Remove prefix `before`, remove suffix `after`, split using `,`,
unquote using `{}`.**

    $ s="before{first item},{second  item},{third item}after"
    $ echo $s | uqaj -j, -p'{' -A before -B after
    first item
    second item
    third item

**Remove prefix `<`, remove suffix `>`, split using `,`, unquote using
`"`.**

    $ s='<"lorem", "ipsum", "dolores", "est">'
    $ echo $s | uqaj -J -A '<' -B '>' -qq
    lorem
    ipsum
    dolores
    est

**Remove prefix `<`, remove suffix `>`, split using `,`, unquote using
`"`.**

    $ s=$'<"lorem",\n"ipsum", "dolores",\n"est">'
    $ echo $s | uqaj -J -A '<' -B '>' -qq
    lorem
    ipsum
    dolores
    est
