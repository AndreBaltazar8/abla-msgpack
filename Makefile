ABLAC_DIR := $(abspath ../ablac)
COMPILER := $(ABLAC_DIR)/build/ablac

.PHONY: check test

check:
	mkdir -p build
	$(COMPILER) build tests/msgpack_test.ab -o build/msgpack-test --fast --no-cache
	build/msgpack-test

test: check
