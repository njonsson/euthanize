#!/usr/bin/env sh

source test/helper.sh

arguments_missing_or_invalid_test() {
  local USAGE='Usage:

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

  local command='./euthanize'
  assert_output_equal "$USAGE"                                  "$command 2>/dev/null"
  assert_output_equal "\033[31mSize option is required.\033[0m" "$command >/dev/null"
  assert_exit_status_equal 1 "$command"

  local command='./euthanize --size'
  assert_output_equal "$USAGE"                                  "$command 2>/dev/null"
  assert_output_equal "\033[31mSize option is required.\033[0m" "$command >/dev/null"
  assert_exit_status_equal 1 "$command"

  local command='./euthanize --size NONNUMERIC'
  assert_output_equal "$USAGE"                                           "$command 2>/dev/null"
  assert_output_equal "\033[31mSize option must be a valid size.\033[0m" "$command >/dev/null"
  assert_exit_status_equal 1 "$command"

  local command='./euthanize --size 123x'
  assert_output_equal "$USAGE"                                           "$command 2>/dev/null"
  assert_output_equal "\033[31mSize option must be a valid size.\033[0m" "$command >/dev/null"
  assert_exit_status_equal 1 "$command"

  local command='./euthanize --size 123mb'
  assert_output_equal "$USAGE"                                    "$command 2>/dev/null"
  assert_output_equal "\033[31mPath argument is required.\033[0m" "$command >/dev/null"
  assert_exit_status_equal 1 "$command"
}
arguments_missing_or_invalid_test
