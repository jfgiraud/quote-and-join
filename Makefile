.ONESHELL:
SHELL=bash

.PHONY: usage
usage:
	@cat - <<EOF
		Targets:
		* install: install scripts in /usr/local/bin
		* uninstall: remove scripts from /usr/local/bin
		* test: run all tests
		* install-asciidoctor: install asciidoctor (you must call this target with sudo)
	EOF

.PHONY: install-asciidoctor
install-asciidoctor:
	apt install asciidoctor

/usr/bin/asciidoctor:
	make install-asciidoctor

.PHONY: update-doc
update-doc: doc/qaj.adoc doc/uqaj.adoc /usr/bin/asciidoctor
	VERSION=v0.0.1
	asciidoctor -b manpage doc/qaj.adoc -o doc/man/man1/qaj.1
	awk -i inplace -v version=$$VERSION '/{release\\?-version}/{gsub(/{release\\?-version}/,version,$$0)} 1' doc/man/man1/qaj.1
	man -l doc/man/man1/qaj.1 > doc/qaj.txt
	[[ -s doc/qaj.txt ]] && awk -i inplace 'BEGIN { p = 1 } /#BEGIN_DO_NOT_MODIFY:make update-doc/{ print; p = 0; while(getline line<"doc/qaj.txt"){print line} } /#END_DO_NOT_MODIFY:make update-doc/{ p = 1 } p' bin/qaj
	rm -f doc/qaj.txt
	asciidoctor -b manpage doc/uqaj.adoc -o doc/man/man1/uqaj.1
	awk -i inplace -v version=$$VERSION '/{release\\?-version}/{gsub(/{release\\?-version}/,version,$$0)} 1' doc/man/man1/uqaj.1
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

.PHONY: archive
archive: update-doc
	zip quote-and-join.zip doc/man/man1/*.1 bin/*qaj

.PHONY: uninstall
uninstall:
	rm -f /usr/local/bin/qaj /usr/local/bin/uqaj



