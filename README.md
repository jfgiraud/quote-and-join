[![Test Status](https://img.shields.io/github/actions/workflow/status/jfgiraud/quote-and-join/main.yml?label=CI)](https://github.com/jfgiraud/quote-and-join/actions)

quote and join utilities
==========================

Small utilities to: 
- quote and join words or lines in files 
- split and unquote words in files

TL;DR:
- qaj [quote and join](#qaj---quote-and-join)
- uqaj [un-(quote and join)](#uqaj---unquote-and-join)

--------------------------

# qaj - quote and join

## description

quote and join words or lines in files

## usage

[doc/qaj.adoc](./doc/qaj.adoc)

## examples

```bash
$ echo lorem ipsum dolores est | qaj -w -q -j,
```

```
'lorem','ipsum','dolores','est'

$ echo lorem ipsum dolores est | qaj -w -qq -j', '
"lorem", "ipsum", "dolores", "est"

$ echo lorem ipsum dolores est | qaj -w -a'<' -b'>' -j# 
<lorem>#<ipsum>#<dolores>#<est>

$ echo lorem ipsum dolores est | qaj -w
lorem
ipsum
dolores
est

$ echo lorem ipsum dolores est | qaj -w -p'<' -j# 
<lorem>#<ipsum>#<dolores>#<est>

$ printf "lorem\nipsum\n dolores\n\nest" | qaj -qq -j, 
"lorem","ipsum","dolores","est"

$ printf "lorem\nipsum\n dolores\n\nest" | qaj -qq -J 
"lorem", "ipsum", "dolores", "est"
```

-----------------------
# uqaj - unquote and join

## description

split and unquote words in files

## usage

[doc/uqaj.adoc](./doc/uqaj.adoc)

## examples

```
$ s="before{first item},{second  item},{third item}after"
$ echo $s | ./uqaj -j, -p'{' -A before -B after
first item
second item
third item

$ s='<"lorem", "ipsum", "dolores", "est">'
$ echo $s | ./uqaj -J -A '<' -B '>' -qq
lorem
ipsum
dolores
est
```
