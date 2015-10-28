# Build (default target)

OUT=./euthanize
MAKEFILE=Makefile
SCRIPT_BUILD=script/build
SRCS=$(shell find src -name *.sh)

$(OUT): $(MAKEFILE) $(SCRIPT_BUILD) $(SRCS)
	$(SCRIPT_BUILD) $(OUT) $(SRCS)


# Test

SCRIPT_TEST=script/run-tests
TEST_RELATED=$(shell find test -name *.sh -and -not -name *_test.sh)
TESTS=$(shell find test -name *_test.sh)
ALL_TEST_DEPENDENCIES=$(MAKEFILE) $(SCRIPT_TEST) $(TEST_RELATED) $(TESTS) $(SRCS) $(OUT)

test: $(ALL_TEST_DEPENDENCIES)
	$(SCRIPT_TEST) $(TESTS)


# Load test

load-test:
	script/run-load-test

load-test-verbose:
	script/run-load-test --verbose


# Install

install: $(MAKEFILE) test $(OUT)
	cp -i $(OUT) /usr/local/bin/
