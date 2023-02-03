.ONESHELL:
SHELL=bash

.PHONY: usage
usage:
	@cat - <<EOF
		Targets:
		* test: run all tests
	EOF

.PHONY: test
test: bin/qaj bin/uqaj
	bash tests/qaj_tests.sh



