.ONESHELL:
SHELL=bash

.PHONY: usage
usage:
	@cat - <<EOF
		Targets:
		* test: run all tests
		* test_qaj: run all qaj tests
		* test_uqaj: run all uqaj tests
	EOF

.PHONY: test_qaj
test_qaj: bin/qaj
	bash tests/qaj_tests.sh

.PHONY: test_uqaj
test_uqaj: bin/uqaj
	bash tests/uqaj_tests.sh

.PHONY: test
test: bin/qaj bin/uqaj
	bash tests/qaj_tests.sh
	bash tests/uqaj_tests.sh



