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
		* commit-release VERSION=v{X.Y.Z}: commit files and create a release
		* update-doc VERSION=v{X.Y.Z}: update man pages and usages
		* install-asciidoctor: install asciidoctor (you must call this target with sudo)
	EOF

.PHONY: install-asciidoctor
install-asciidoctor:
	apt install asciidoctor

/usr/bin/asciidoctor:
	echo "You must install asciidoctor."
	echo "sudo make install-asciidoctor"

.PHONY: update-doc
update-doc: doc/qaj.adoc doc/uqaj.adoc /usr/bin/asciidoctor
	[[ -z $$VERSION ]] && echo "Version not set!" && exit 1
	VERSION=$${VERSION#*v}
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

.PHONY: commit-release
commit-release: clean update-doc
	[[ -z $$VERSION ]] && echo "Version not set!" && exit 1
	VERSION=$${VERSION#*v}
	git add .
	git commit -m "Commit for creating tag $$VERSION"
	git tag "v$$VERSION"
	git push


.PHONY: test
test:
	bash tests/qaj_tests.sh
	bash tests/uqaj_tests.sh

.PHONY: install
install: archive
	tar zxvf quote-and-join.tar.gz -C /usr/local/

.PHONY: archive
archive:
	tar cvf quote-and-join.tar bin/*qaj
	tar rvf quote-and-join.tar LICENSE --transform 's,^,share/doc/quote-and-join/,'
	tar rvf quote-and-join.tar doc/man/man1/*.1 --transform 's,^doc/,,'
	gzip -f quote-and-join.tar

.PHONY: uninstall
uninstall:
	cd /usr/local/
	rm -f bin/{qaj,uqaj}
	rm -f man/man1/{qaj,uqaj}.1
	rm -f share/doc/quote-and-join/LICENSE

.PHONY: clean
clean:
	rm -f *.tar *.gz *~


