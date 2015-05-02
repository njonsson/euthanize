#!/usr/bin/env sh

source src/support.sh
source test/helper.sh

say_test() {
  assert_output_equal 'foo'      'say foo'
  assert_output_equal 'foo'      'say "foo"'
  assert_output_equal 'foo'      "say \"foo\""
  assert_output_equal 'foo'      'say -n foo'
  assert_output_equal 'foo'      "say -n 'foo'"
  assert_output_equal "foo\nbar" 'say foo bar'
  assert_output_equal 'foo bar'  "say 'foo bar'"
  assert_output_equal 'foobar'   'say -n foo bar'
  assert_output_equal 'foo bar'  'say -n "foo bar"'
}
say_test
