# ![qaj Logo](https://raw.githubusercontent.com/jfgiraud/qaj/master/qaj.png) uqaj

### description

uqaj is a small utility to split and unquote words in files.

### usage

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

### examples

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
