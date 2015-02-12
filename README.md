# ![cot Logo](https://raw.githubusercontent.com/jfgiraud/cot/master/cot.png) cot

### description

cot is a small utility to quote and join words or lines in files.

### usage

```
cot [ -w | -l ] [ [ -a <string> | -b <string> | -c <string> ] | [ -p <string> ] | [ -q | -qq ] ] [ -j <string> | J ] [ [ -s | -S ] | -u ] [ -t ] [ -e ]

Where:

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

Join items:
     -j  <string>  
     -J  [ie , ]
```

### examples of use

```
$ echo lorem ipsum dolores est | cot -w -q -j,
'lorem','ipsum','dolores','est'

$ echo lorem ipsum dolores est | cot -w -qq -j', '
"lorem", "ipsum", "dolores", "est"

$ echo lorem ipsum dolores est | cot -w -a'<' -b'>' -j# 
<lorem>#<ipsum>#<dolores>#<est>

$ echo lorem ipsum dolores est | cot -w
lorem
ipsum
dolores
est

$ echo lorem ipsum dolores est | cot -w -p'<' -j# 
<lorem>#<ipsum>#<dolores>#<est>

$ printf "lorem\nipsum\n dolores\n\nest" | cot -qq -j, 
"lorem","ipsum","dolores","est"

$ printf "lorem\nipsum\n dolores\n\nest" | cot -qq -J 
"lorem", "ipsum", "dolores", "est"
```
