![<https://github.com/jfgiraud/quote-and-join/actions>](https://img.shields.io/github/actions/workflow/status/jfgiraud/quote-and-join/main.yml?label=CI)

quote and join utilities
========================

Small utilities to:

-   quote and join words or lines in files

-   split and unquote words in files

TLDR
====

qaj
---

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

uqaj
----

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

usage qaj
=========

Select and sort items
---------------------

**-w**  
Select words.

**-l**  
Select lines.

**-s**  
Sort items in lexicographic order.

**-S**  
Sort items in reverse lexicographic order.

**-u**  
Remove duplicate items (implies **-s** or **-S** option).

Prefix and/or suffix items
--------------------------

**-q**  
Quote items with the character `'`.

**-qq**  
Quote items with the character `"`.

**-a** *string*  
Prefix each items with the given string.

**-b** *string*  
Suffix each items with the given string.

**-c** *string*  
Prefix and suffix each items with the given string.

**-p** *string*  
The given string must be `<`, `{`, `(` or `[`. Prefix each items with
the given string. Suffix each items with the associated closing
parenthese of the given parenthese.

**-t**  
Do not trim item.

**-e**  
Do not escape parentheses in item.

Join the prefixed/suffixed items
--------------------------------

**-j** *string*  
Use the given string to join quoted items.

**-J**  
Use the character `,` to join quoted items.

Prefix and/or suffix the final result
-------------------------------------

After the process of quoting, sorting and/or jointing:

**-A** *string*  
Prefix the result with the given string.

**-B** *string*  
Suffix the result with the given string.

**-C** *string*  
Prefix and suffix the result with the given string.

**-P** *string*  
The given parenthese must be `<`, `{`, `(` or `[`. Prefix the result
with the given parenthese and suffix the result with the associated
closing parenthese.

usage uqaj
==========

Unquoting
---------

**-q**  
Unquote items with the character `'`

**-qq**  
Unquote items with the character `"`

**-a** *string*  
Remove prefix specified by string

**-b** *string*  
Remove suffix specified by string

**-c** *string*  
Remove prefix and suffix specified by string

**-p** *string*  
The given string must be `<`, `{`, `(` or `[`. Remove the given
parenthese and associated closing parenthese of each items.

Splitting
---------

**-j** *string*  
Split using the given string

**-J**  
Split using the character `,`

Before the process of splitting and unquoting
---------------------------------------------

**-A** *string*  
Remove prefix specified by string

**-B** *string*  
Remove suffix specified by string

**-C** *string*  
Remove prefix and suffix specified by string

**-P** *string*  
Remove prefix (parenthese is `<`, `{`, `(` or `[`) and suffix
(associated parenthese).
