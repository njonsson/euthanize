#!/usr/bin/env sh

source test/helper.sh

version_test() {
  local VERSION=0.0.1

  local command='./euthanize --version'
  assert_output_equal $VERSION "$command"
  assert_exit_status_equal 0 "$command"

  local command='./euthanize -v'
  assert_output_equal $VERSION "$command"
  assert_exit_status_equal 0 "$command"
}
version_test
