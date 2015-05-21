#!/usr/bin/env sh

source src/support.sh
source test/helper.sh

say_verbose_test() {
  unset verbose
  assert_output_equal '' 'say_verbose foo'

  verbose=false
  assert_output_equal '' 'say_verbose foo'

  verbose=0
  assert_output_equal '' 'say_verbose foo'

  verbose=true

  assert_output_equal 'foo' 'say_verbose foo >/dev/null'
  assert_output_equal ''    'say_verbose foo 2>/dev/null'

  assert_output_equal 'foo'      'say_verbose "foo"'
  assert_output_equal 'foo'      "say_verbose \"foo\""
  assert_output_equal 'foo'      'say_verbose -n foo'
  assert_output_equal 'foo'      "say_verbose -n 'foo'"
  assert_output_equal "foo\nbar" 'say_verbose foo bar'
  assert_output_equal 'foo bar'  "say_verbose 'foo bar'"
  assert_output_equal 'foobar'   'say_verbose -n foo bar'
  assert_output_equal 'foo bar'  'say_verbose -n "foo bar"'

  unset verbose
}
say_verbose_test
