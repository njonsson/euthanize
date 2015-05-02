#!/usr/bin/env sh

source test/helper.sh

version_test() {
  local VERSION=0.0.1

  assert_expression_equal $VERSION './euthanize --version'
  assert_expression_equal $VERSION './euthanize -v'
}
version_test
