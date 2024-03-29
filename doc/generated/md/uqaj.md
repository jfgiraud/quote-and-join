NAME
====

uqaj - split and unquote lines in files

SYNOPSIS
========

**uqaj** \[*OPTION*\]…​ \[*FILE*\]…​

DESCRIPTION
===========

Split and unquote lines in files

With no FILE, or when FILE is `-`, read standard input.

OPTIONS
=======

**-h**  
Display help.

**-v**  
Display version.

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

EXAMPLES
========

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
