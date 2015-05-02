#!/usr/bin/env sh

source src/support/util.sh
source test/helper.sh

inquire_test() {
  assert_output_equal "Doing nothing ... \033[32myes\033[0m"               "inquire 'Doing nothing'"
  assert_output_equal "Doing something successful ... \033[32myes\033[0m"  'inquire "Doing something successful" ls'
  assert_output_equal "Doing something unsuccessful ... \033[31mno\033[0m" "inquire \"Doing something unsuccessful\" 'ls nonexistent-file 2>/dev/null'"
  assert_output_equal "Doing something unsuccessful ... \033[31mno\033[0m" "inquire 'Doing something unsuccessful' ls \"ls nonexistent-file 2>/dev/null\""
}
inquire_test
