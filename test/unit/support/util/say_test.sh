#!/usr/bin/env sh

source test/helper.sh
source src/support/util.sh

assert_expression_equal 'foo'      'say foo'
assert_expression_equal 'foo'      'say -n foo'
assert_expression_equal "foo\nbar" 'say foo bar'
assert_expression_equal 'foobar'   'say -n foo bar'
