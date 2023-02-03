.ONESHELL:
SHELL=bash

.PHONY: usage
usage:
	@cat - <<EOF
		Targets:
		* test: run all tests
		* install: install scripts in /usr/local/bin
		* uninstall: remove scripts from /usr/local/bin
	EOF


doc/man/man1/qaj.1: doc/qaj.adoc
	asciidoctor -b manpage doc/qaj.adoc -o doc/man/man1/qaj.1

.PHONY: doc
doc: doc/man/man1/qaj.1

.PHONY: test
test:
	bash tests/qaj_tests.sh
	bash tests/uqaj_tests.sh

.PHONY: install
install:
	cp -i bin/qaj /usr/local/bin/qaj
	cp -i bin/uqaj /usr/local/bin/uqaj

.PHONY: uninstall
uninstall:
	rm -f /usr/local/bin/qaj /usr/local/bin/uqaj



