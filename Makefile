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


.PHONY: update-doc
update-doc: doc/qaj.adoc doc/uqaj.adoc
	asciidoctor -b manpage doc/qaj.adoc -o doc/man/man1/qaj.1
	sed -ri 's/\{release(\\)?-version\}/v1.0.0/g' doc/man/man1/qaj.1
	man -l doc/man/man1/qaj.1 > doc/qaj.txt
	[[ -s doc/qaj.txt ]] && awk -i inplace 'BEGIN { p = 1 } /#BEGIN_DO_NOT_MODIFY:make update-doc/{ print; p = 0; while(getline line<"doc/qaj.txt"){print line} } /#END_DO_NOT_MODIFY:make update-doc/{ p = 1 } p' bin/qaj
	rm -f doc/qaj.txt
	asciidoctor -b manpage doc/uqaj.adoc -o doc/man/man1/uqaj.1
	sed -ri 's/\{release(\\)?-version\}/v1.0.0/g' doc/man/man1/uqaj.1
	man -l doc/man/man1/uqaj.1 > doc/uqaj.txt
	[[ -s doc/uqaj.txt ]] && awk -i inplace 'BEGIN { p = 1 } /#BEGIN_DO_NOT_MODIFY:make update-doc/{ print; p = 0; while(getline line<"doc/uqaj.txt"){print line} } /#END_DO_NOT_MODIFY:make update-doc/{ p = 1 } p' bin/uqaj
	rm -f doc/uqaj.txt

.PHONY: test
test:
	bash tests/qaj_tests.sh
	bash tests/uqaj_tests.sh

.PHONY: install
install: update-doc
	cp -i bin/qaj /usr/local/bin/qaj
	cp -i bin/uqaj /usr/local/bin/uqaj
	cp -i doc/man/man1/qaj.1 /usr/local/man/man1/
	cp -i doc/man/man1/uqaj.1 /usr/local/man/man1/

.PHONY: uninstall
uninstall:
	rm -f /usr/local/bin/qaj /usr/local/bin/uqaj



