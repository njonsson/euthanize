BIN=bin/euthanize
MAKEFILE=Makefile
SCRIPT_BUILD=script/build
SRCS=$(shell find src -name *.sh)

SCRIPT_TEST=script/run-tests
TESTS=$(shell find test -name *_test.sh)

$(BIN): $(MAKEFILE) $(SCRIPT_BUILD) $(SRCS)
	$(SCRIPT_BUILD) $(BIN) $(SRCS)

test: $(MAKEFILE) $(SCRIPT_TEST) $(TESTS) $(SRCS) $(BIN)
	$(SCRIPT_TEST) $(TESTS)
