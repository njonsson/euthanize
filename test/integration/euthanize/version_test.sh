#!/usr/bin/env sh

source test/helper.sh

assert_expression_equal '0.0.1' 'bin/euthanize --version'
assert_expression_equal '0.0.1' 'bin/euthanize -v'
