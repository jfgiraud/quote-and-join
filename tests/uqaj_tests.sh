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
    "echo 'before{first item},{second item},{third item}after' | ../bin/uqaj -j, -p'{' -A before -B after" \
    $'first item\nsecond item\nthird item'

assert_exec_equals \
    "echo '<\"lorem\", \"ipsum\", \"dolores\", \"est\">' | ../bin/uqaj -J -A '<' -B '>' -qq" \
    $'lorem\nipsum\ndolores\nest'

assert_exec_equals \
    "echo '[a,b,c]' | ../bin/uqaj -j',' -P'['" \
    $'a\nb\nc'

assert_exec_equals \
    "echo '[a, b, c]' | ../bin/uqaj -J -P'['" \
    $'a\nb\nc'

assert_exec_equals \
    "echo '[ a, b, c ]' | ../bin/uqaj -J -P'['" \
    $'a\nb\nc'

assert_exec_equals \
    'printf "[\"a\",\n\"b\",\n\"c\"\n]" | ../bin/uqaj -P"[" -j",\n" -qq' \
    $'a\nb\nc'

echo "${ok}/${total} (${ko} errors)"

if [[ ${ok} -ne ${total} ]]; then
    exit 1
else
    exit 0
fi
