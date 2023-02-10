DESTDIR ?= /usr/local
PACKAGE_NAME ?= quote-and-join
SCRIPTS = qaj uqaj
GENERATED_FILES = doc/generated/man/man1/qaj.1 doc/generated/txt/qaj.1.txt doc/generated/man/man1/uqaj.1 doc/generated/txt/uqaj.1.txt doc/generated/md/qaj.md doc/generated/md/uqaj.md
VERSION ?= $(shell cat doc/VERSION)
FILE_VERSION ?= $(shell cat doc/VERSION)

.ONESHELL:
SHELL=bash

## https://svn.lal.in2p3.fr/LCG/QWG/External/docbook-xsl-ns-1.74.0/tools/make/Makefile.DocBook

.PHONY: usage
usage:
	@cat - <<EOF
		Targets:
		* install: install scripts in /usr/local/bin (you must call this target with sudo)
		* uninstall: remove scripts from /usr/local/bin
		* test: run all tests
		* archive: create a tgz (used in github pipeline for release)
		* commit-release VERSION=X.Y.Z: commit files and create a release
		* update-doc: update man pages and usages
		* install-dependencies: install dependencies (you must call this target with sudo)
	EOF

.PHONY: install-dependencies
install-dependencies:
	apt install asciidoctor
	apt install pandoc

/usr/bin/asciidoctor:
	echo "You must install dependencies."
	echo "sudo make install-dependencies"

doc/generated/man/man1/%.1: doc/%.adoc doc/VERSION
	@echo "Create $@"
	@asciidoctor -b manpage -a release-version="$(VERSION)" $< -o $@

doc/generated/md/%.md: doc/%.adoc doc/VERSION
	@echo "Create $@"
	@SCRIPT=$(shell basename "$@" | sed 's/\..*//')
	@asciidoctor -b docbook doc/$$SCRIPT.adoc -o doc/generated/md/$$SCRIPT.xml
	@pandoc -t gfm+footnotes -f docbook -t markdown_strict doc/generated/md/$$SCRIPT.xml -o doc/generated/md/$$SCRIPT.md
	@rm -f doc/generated/md/$$SCRIPT.xml

doc/generated/txt/%.1.txt: doc/generated/man/man1/%.1 doc/VERSION
	@echo "Create $@"
	@man -l $< > $@
	@SCRIPT=$(shell basename "$@" | sed 's/\..*//')
	@echo "Rewrite usage in $$SCRIPT"
	@awk -i inplace -v input="$@" 'BEGIN { p = 1 } /#BEGIN_DO_NOT_MODIFY:make update-doc/{ print; p = 0; while(getline line<input){print line} } /#END_DO_NOT_MODIFY:make update-doc/{ p = 1 } p' bin/$$SCRIPT

.PHONY: update-version
update-version:
	[[ "$(VERSION)" == "$(FILE_VERSION)" ]] && echo "Change version number! (make update-version VERSION=X.Y.Z)" && exit 1
	@echo "Modify version in doc/VERSION"
	@echo "$(VERSION)" > doc/VERSION

.PHONY: update-doc
update-doc: $(GENERATED_FILES)

.PHONY: commit-release
commit-release: update-version
	@echo "Update documentation"
	make update-doc
	@echo "Commit release $$VERSION"
	git add .
	git commit -m "Commit for creating tag v$$VERSION"
	git tag "v$$VERSION" -m "Tag v$$VERSION"
	git push --tags

.PHONY: test
test:
	bash tests/qaj_tests.sh
	bash tests/uqaj_tests.sh


$(PACKAGE_NAME).tar.gz: $(PACKAGE_NAME).tar
	@echo "Compress archive $@"
	@gzip -f $<

$(PACKAGE_NAME).tar: update-doc
	@echo "Create archive $@"
	@tar cf $(PACKAGE_NAME).tar bin/*
	@tar rf $(PACKAGE_NAME).tar LICENSE --transform 's,^,share/doc/$(PACKAGE_NAME)/,'
	@tar rf $(PACKAGE_NAME).tar doc/generated/man/man1/*.1 --transform 's,^doc/generated/,,'

.PHONY: archive
archive: $(PACKAGE_NAME).tar.gz

.PHONY: install
install: $(PACKAGE_NAME).tar.gz
	@echo "Install software to $(DESTDIR)"
	tar zxvf $(PACKAGE_NAME).tar.gz -C $(DESTDIR)

.PHONY: uninstall
uninstall:
	@echo "Uninstall software from $(DESTDIR)"
	@for script in $(SCRIPTS); do
	@	rm -f $(DESTDIR)/bin/$$script $(DESTDIR)/man/man1/$$script.1
	@done
	@rm -rf $(DESTDIR)/share/doc/$(PACKAGE_NAME)/

.PHONY: clean
clean:
	@echo "Clean files"
	@rm -f $(PACKAGE_NAME).tar.gz


