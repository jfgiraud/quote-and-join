# ![qaj Logo](https://raw.githubusercontent.com/jfgiraud/qaj/master/qaj.png) qaj

### description

qaj is a small utility to **q**uote **a**nd **j**oin words or lines in files.

### usage

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


