#!/usr/bin/env sh

source test/helper.sh

assert_expression_equal '0.0.1' './euthanize --version'
assert_expression_equal '0.0.1' './euthanize -v'
