OUT=./euthanize
MAKEFILE=Makefile
SCRIPT_BUILD=script/build
SRCS=$(shell find src -name *.sh)

SCRIPT_TEST=script/run-tests
TESTS=$(shell find test -name *_test.sh)

$(OUT): $(MAKEFILE) $(SCRIPT_BUILD) $(SRCS)
	$(SCRIPT_BUILD) $(OUT) $(SRCS)

test: $(MAKEFILE) $(SCRIPT_TEST) $(TESTS) $(SRCS) $(OUT)
	$(SCRIPT_TEST) $(TESTS)
