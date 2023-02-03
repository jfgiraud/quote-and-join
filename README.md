[![Test Status](https://img.shields.io/github/actions/workflow/status/jfgiraud/quote-and-join/test.yml?label=Tests)](https://github.com/jfgiraud/quote-and-join/actions)

quote and join utilities
==========================

small utilities to: 
- quote and join words or lines in files 
- split and unquote words in files

Links :
- qaj [quote and join](#qaj---quote-and-join)
- uqaj [un-(quote and join)](#uqaj---unquote-and-join)

--------------------------

# qaj - quote and join

## description

qaj is a small utility to **q**uote **a**nd **j**oin words or lines in files.

## usage

```
qaj [OPTION]... [FILE]...

    OPTION:

        Item selector:
             -w   word
             -l   line

        Quote:
             -q  [ie ']         (left+right)
             -qq [ie "]         (left+right)
             -a  <string>       (left)
             -b  <string>       (right)
             -c  <string>       (left+right)
             -p  <parenthese>   (left+right) where parenthese must be <, {, ( or [
                                right parenthese will be the closing parenthese
             -t   do not trim item
             -e   do not escape parentheses in item

        Sort:
             -s  sort
             -S  sort in reverse order
             -u  remove duplicate items (implies -s or -S option)

        Join delimiter:
             -j  <string>
             -J  [ie , ]

        After the process of quoting, sorting and/or jointing:
             -A <string>        append string to the left on the final result
             -B <string>        append string to the right on the final result
             -C <string>        append string to the left+right on the final result
```

## examples

```
$ echo lorem ipsum dolores est | qaj -w -q -j,
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

uqaj is a small utility to split and unquote words in files.

## usage

```
uqaj [OPTION]... [FILE]...

    OPTION:

        Unquoting:
             -q  [ie ']         (left+right)
             -qq [ie "]         (left+right)
             -a  <string>       (left)
             -b  <string>       (right)
             -c  <string>       (left+right)
             -p  <parenthese>   (left+right) where parenthese must be <, {, ( or [
                                right parenthese will be the closing parenthese
        
        Splitting:
             -j  <string>
             -J  [ie , ]
        
        Before the process of splitting and unquoting:
             -A <string>        remove string to the left
             -B <string>        remove string to the right
             -C <string>        remove string to the left+right
```

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
