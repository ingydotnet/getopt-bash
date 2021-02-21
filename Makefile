SHELL := bash
ROOT := $(shell pwd)

TEST-MORE := $(ROOT)/test/.test-more-bash
TEST-MORE-URL := https://github.com/ingydotnet/test-more-bash
export PATH := $(ROOT)/lib:$(TEST-MORE)/lib:$(PATH)

test ?= test/*.t

.PHONY: test
test: $(TEST-MORE)
	prove -v $(test)

clean:
	rm -fr $(TEST-MORE)

$(TEST-MORE):
	git clone $(TEST-MORE-URL) $@
