#!/usr/bin/env sh

source src/support/util.sh
source test/helper.sh

assert_expression_equal foo 'format foo'

assert_expression_equal "\033[1mfoo\033[0m"  'format bold foo'
assert_expression_equal "\033[4mfoo\033[0m"  'format underlined foo'
assert_expression_equal "\033[5mfoo\033[0m"  'format blinking foo'
assert_expression_equal "\033[7mfoo\033[0m"  'format inverse foo'
assert_expression_equal "\033[30mfoo\033[0m" 'format foreground_black foo'
assert_expression_equal "\033[31mfoo\033[0m" 'format foreground_red foo'
assert_expression_equal "\033[32mfoo\033[0m" 'format foreground_green foo'
assert_expression_equal "\033[33mfoo\033[0m" 'format foreground_yellow foo'
assert_expression_equal "\033[34mfoo\033[0m" 'format foreground_blue foo'
assert_expression_equal "\033[35mfoo\033[0m" 'format foreground_magenta foo'
assert_expression_equal "\033[36mfoo\033[0m" 'format foreground_cyan foo'
assert_expression_equal "\033[37mfoo\033[0m" 'format foreground_gray foo'
assert_expression_equal "\033[39mfoo\033[0m" 'format foreground_default foo'
assert_expression_equal "\033[40mfoo\033[0m" 'format background_black foo'
assert_expression_equal "\033[41mfoo\033[0m" 'format background_red foo'
assert_expression_equal "\033[42mfoo\033[0m" 'format background_green foo'
assert_expression_equal "\033[43mfoo\033[0m" 'format background_yellow foo'
assert_expression_equal "\033[44mfoo\033[0m" 'format background_blue foo'
assert_expression_equal "\033[45mfoo\033[0m" 'format background_magenta foo'
assert_expression_equal "\033[46mfoo\033[0m" 'format background_cyan foo'
assert_expression_equal "\033[47mfoo\033[0m" 'format background_gray foo'
assert_expression_equal "\033[49mfoo\033[0m" 'format background_default foo'

assert_expression_equal "\033[7;34mfoo\033[0m" 'format inverse foreground_blue foo'
