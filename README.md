# ![qaj Logo](https://raw.githubusercontent.com/jfgiraud/qaj/master/qaj.png) qaj

### description

qaj is a small utility to **q**uote **a**nd **j**oin words or lines in files.

### usage

```
qaj [ -w | -l ] [ [ -a <string> | -b <string> | -c <string> ] | [ -p <string> ] | [ -q | -qq ] ] [ -j <string> | J ] [ [ -s | -S ] | -u ] [ -t ] [ -e ]

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

### examples

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
