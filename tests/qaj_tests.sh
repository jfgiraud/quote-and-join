#!/bin/bash

cd $(dirname $(readlink -f $0))

total=0
ok=0
ko=0

function assert_equals() {
    total=$((total+1))
    expected="$1"
    actual="$2"
    message="$3"
    if [[ "$expected" == "$actual" ]]; then
        ok=$((ok+1))
        echo "OK: ${message}" >&2
    else
        ko=$((ko+1))
        echo "KO: ${message}" >&2
        echo "   expects: ${expected}" >&2
        echo "   but receives: ${actual}" >&2
    fi
}

function assert_exec_equals() {
    command="${1}"
    actual=$(eval "${command}")
    expected="${2}"
    assert_equals "${expected}" "${actual}" "${command}"

}

assert_exec_equals \
    "echo lorem ipsum dolores est | ../bin/qaj -w -q -j," \
     "'lorem','ipsum','dolores','est'"

assert_exec_equals \
    "echo lorem ipsum dolores est | ../bin/qaj -w -qq -j', '" \
    '"lorem", "ipsum", "dolores", "est"'

assert_exec_equals \
    "echo lorem ipsum dolores est | ../bin/qaj -w -a'<' -b'>' -j#" \
    "<lorem>#<ipsum>#<dolores>#<est>"

assert_exec_equals \
    'echo lorem ipsum dolores est | ../bin/qaj -w' \
    "lorem
ipsum
dolores
est"

assert_exec_equals \
    "echo lorem ipsum dolores est | ../bin/qaj -w -p'<' -j#" \
    "<lorem>#<ipsum>#<dolores>#<est>"

assert_exec_equals \
    'printf "lorem\nipsum\n dolores\n\nest" | ../bin/qaj -qq -j,' \
    '"lorem","ipsum","dolores","est"'

assert_exec_equals \
    'printf "lorem\nipsum\n dolores\n\nest" | ../bin/qaj -qq -J' \
    '"lorem", "ipsum", "dolores", "est"'

assert_exec_equals \
    'printf "lorem\nipsum\n dolores\n\nest" | ../bin/qaj -qq -t -J' \
    '"lorem", "ipsum", " dolores", "est"'

assert_exec_equals \
    'printf "lorem\nipsum\n dolores\n\nest" | ../bin/qaj -qq -J -A "<" -B ">"' \
    '<"lorem", "ipsum", "dolores", "est">'

echo "${ok}/${total} (${ko} errors)"

if [[ ${ok} -ne ${total} ]]; then
    exit 1
else
    exit 0
fi
