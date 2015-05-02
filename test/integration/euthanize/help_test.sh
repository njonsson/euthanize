#!/usr/bin/env sh

source test/helper.sh

function help_test() {
  local HELP='Deletes least-recently-used files in a directory.

Usage:

euthanize --size SIZE PATH
euthanize  -s    SIZE PATH

  Deletes files in PATH only if PATH is estimated to exceed SIZE, which is
  interpreted as a number of 512-byte blocks. If SIZE is followed by a scale
  indicator, then it is scaled as:

    kb  kilobytes (1024 bytes)
    mb  megabytes (1024 kilobytes)
    gb  gigabytes (1024 megabytes)
    tb  terabytes (1024 gigabytes)
    pb  petabytes (1024 terabytes)

  PATH must be an existing directory or regular file.'

  local command='./euthanize --help'
  assert_output_equal "$HELP" "$command"
  assert_exit_status_equal 0 "$command"

  local command='./euthanize -h'
  assert_output_equal "$HELP" "$command"
  assert_exit_status_equal 0 "$command"
}
help_test
