quote and join utilities
========================

Small utilities to:

-   quote and join words or lines in files

-   split and unquote words in files

usage
=====

-   [qaj](doc/generated/md/qaj.md)

-   [uqaj](doc/generated/md/uqaj.md)

qaj examples
============

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

uqaj examples
=============

**Remove prefix `before`, remove suffix `after`, split using `,`,
unquote using `{}`.**

    $ s="before{first item},{second  item},{third item}after"
    $ echo $s | ./uqaj -j, -p'{' -A before -B after
    first item
    second item
    third item

**Remove prefix `<`, remove suffix `>`, split using `, `, unquote using
`"`.**

    $ s='<"lorem", "ipsum", "dolores", "est">'
    $ echo $s | ./uqaj -J -A '<' -B '>' -qq
    lorem
    ipsum
    dolores
    est
