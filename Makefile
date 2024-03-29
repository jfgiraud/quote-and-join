DESTDIR ?= /usr/local
REPOSITORY_NAME ?= quote-and-join
SCRIPTS = qaj uqaj
BIN_SCRIPTS = $(foreach script,$(SCRIPTS),bin/$(script))
GENERATED_FILES = doc/generated/man/man1/qaj.1 doc/generated/txt/qaj.1.txt doc/generated/man/man1/uqaj.1 doc/generated/txt/uqaj.1.txt doc/generated/md/qaj.md doc/generated/md/uqaj.md doc/generated/md/readme.md
VERSION ?= $(shell cat doc/VERSION)
FILE_VERSION ?= $(shell cat doc/VERSION)
TESTS = tests/qaj_tests.sh tests/uqaj_tests.sh


.ONESHELL:
SHELL=bash

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
		* update-version VERSION=X.Y.Z: update man pages and usages
		* install-dependencies: install dependencies (you must call this target with sudo)
	EOF

.PHONY: install-dependencies
install-dependencies:
	apt install asciidoctor
	apt install pandoc

/usr/bin/asciidoctor:
	echo "You must install dependencies."
	echo "sudo make install-dependencies"

.PHONY: update-year
update-year:
	@echo "Update year in doc/copyright.adoc"
	@year=$(shell date +'%Y')
	@sed -ri "s#Copyright \(C\) [0-9]{4}#Copyright (C) $$year#" doc/copyright.adoc

doc/generated/man/man1/%.1: doc/%.adoc doc/VERSION doc/copyright.adoc
	@echo "Create $@"
	@asciidoctor -b manpage -a release-version="$(VERSION)" $< -o $@

doc/generated/md/%.md: doc/%.adoc doc/VERSION doc/copyright.adoc
	@echo "Create $@"
	@SCRIPT=$(shell basename "$@" | sed 's/\..*//')
	@asciidoctor -b docbook doc/$$SCRIPT.adoc -o doc/generated/md/$$SCRIPT.xml
	@pandoc -t gfm+footnotes -f docbook -t markdown_strict doc/generated/md/$$SCRIPT.xml -o doc/generated/md/$$SCRIPT.md
	@rm -f doc/generated/md/$$SCRIPT.xml

doc/generated/txt/%.1.txt: doc/generated/man/man1/%.1 doc/VERSION doc/copyright.adoc
	@echo "Create $@"
	@man -l $< > $@
	@SCRIPT=$(shell basename "$@" | sed 's/\..*//')
	@echo "Rewrite usage in $$SCRIPT"
	@awk -i inplace -v input="$@" 'BEGIN { p = 1 } /^#BEGIN_DO_NOT_MODIFY:make update-doc/{ print; p = 0; while(getline line<input){print line} } /^#END_DO_NOT_MODIFY:make update-doc/{ p = 1 } p' bin/$$SCRIPT

README.md: doc/generated/md/readme.md
	@echo "Generate README.md"
	@printf "\n[//]: # (This file is generated, modify doc/readme.adoc and regenerate it with 'make update-doc')\n\n" > README.md
	@cat doc/generated/md/readme.md >> README.md
	@rm -f doc/generated/md/readme.md

.PHONY: update-version
update-version:
	[[ "$(VERSION)" == "$(FILE_VERSION)" ]] && echo "Change version number! (make update-version VERSION=X.Y.Z)" && exit 1
	! grep -Eq "^## ${VERSION}\b" CHANGELOG.md && echo "No information about this version in CHANGELOG.md. Add an entry in CHANGELOG.md!" && exit 1
	@echo "Modify version in doc/VERSION"
	@echo "$(VERSION)" > doc/VERSION
	make update-doc

.PHONY: update-doc
update-doc: $(GENERATED_FILES) README.md

.PHONY: update-script
update-script: $(BIN_SCRIPTS) doc/VERSION

.PHONY: commit-release
commit-release: update-version
	@echo "Update documentation"
	make update-year
	make update-doc
	@echo "Commit release $$VERSION"
	git add -u .
	git commit -m "Commit for creating tag v$$VERSION"
	git push
	git tag "v$$VERSION" -m "Tag v$$VERSION"
	git push --tags

.PHONY: test
test:
	@echo "Run tests"
	@for t in $(TESTS); do
	@echo "Run $$t"
	@	bash $$t
	@done

$(REPOSITORY_NAME).tar.gz: $(REPOSITORY_NAME).tar
	@echo "Compress archive $@"
	@gzip -f $<

$(REPOSITORY_NAME).tar: update-doc
	@echo "Create archive $@"
	@tar cf $(REPOSITORY_NAME).tar bin/*
	@tar rf $(REPOSITORY_NAME).tar LICENSE --transform 's,^,share/doc/$(REPOSITORY_NAME)/,'
	@tar rf $(REPOSITORY_NAME).tar doc/generated/man/man1/*.1 --transform 's,^doc/generated/,,'

.PHONY: archive
archive: $(REPOSITORY_NAME).tar.gz

.PHONY: install
install: $(REPOSITORY_NAME).tar.gz
	@echo "Install software to $(DESTDIR)"
	tar zxvf $(REPOSITORY_NAME).tar.gz -C $(DESTDIR)

.PHONY: uninstall
uninstall:
	@echo "Uninstall software from $(DESTDIR)"
	@for script in $(SCRIPTS); do
	@	rm -f $(DESTDIR)/bin/$$script $(DESTDIR)/man/man1/$$script.1
	@done
	@rm -rf $(DESTDIR)/share/doc/$(REPOSITORY_NAME)/

.PHONY: clean
clean:
	@echo "Clean files"
	@rm -f $(REPOSITORY_NAME).tar.gz doc/generated/md/readme.md


