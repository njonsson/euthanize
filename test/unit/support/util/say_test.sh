#!/usr/bin/env sh

source src/support/util.sh
source test/helper.sh

say_test() {
  assert_expression_equal 'foo'      'say foo'
  assert_expression_equal 'foo'      'say "foo"'
  assert_expression_equal 'foo'      "say \"foo\""
  assert_expression_equal 'foo'      'say -n foo'
  assert_expression_equal 'foo'      "say -n 'foo'"
  assert_expression_equal "foo\nbar" 'say foo bar'
  assert_expression_equal 'foo bar'  "say 'foo bar'"
  assert_expression_equal 'foobar'   'say -n foo bar'
  assert_expression_equal 'foo bar'  'say -n "foo bar"'
}
say_test
