# Build (default target)

OUT=./euthanize
MAKEFILE=Makefile
SCRIPT_BUILD=script/build
SRCS=$(shell find src -name *.sh)

$(OUT): $(MAKEFILE) $(SCRIPT_BUILD) $(SRCS)
	$(SCRIPT_BUILD) $(OUT) $(SRCS)


# Test

SCRIPT_TEST=script/run-tests
TEST_RELATED=$(shell find test -name *.sh)
TESTS=$(shell find test -name *_test.sh)
TEST_RUN=.test-run

test: $(MAKEFILE) $(SCRIPT_TEST) $(TEST_RELATED) $(TESTS) $(SRCS) $(OUT)
	rm -f $(TEST_RUN); $(SCRIPT_TEST) $(TESTS) &>$(TEST_RUN); result=$$?; cat $(TEST_RUN); exit $$result

$(TEST_RUN): $(MAKEFILE) $(SCRIPT_TEST) $(TEST_RELATED) $(TESTS) $(SRCS) $(OUT)
	exit 1


# Install

install: $(MAKEFILE) test $(OUT)
	cp -i $(OUT) /usr/local/bin/
