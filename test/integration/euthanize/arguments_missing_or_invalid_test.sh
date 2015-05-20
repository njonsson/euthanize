#!/usr/bin/env sh

source test/helper.sh

arguments_missing_or_invalid_test() {
  local USAGE='Usage:

euthanize --size SIZE PATH
euthanize  -s    SIZE PATH

  Deletes files in PATH only if PATH is estimated to exceed SIZE, which is
  interpreted as a number of bytes. If SIZE includes a scale indicator, then it
  is scaled as:

    kb   kilobytes (1000 bytes)
    mb   megabytes (1000 kilobytes)
    gb   gigabytes (1000 megabytes)
    tb   terabytes (1000 gigabytes)
    pb   petabytes (1000 terabytes)
    eb   exabytes (1000 petabytes)
    zb   zettabytes (1000 exabytes)
    yb   yottabytes (1000 zettabytes)

    kib  kibibytes (1024 bytes)
    mib  mebibytes (1024 kibibytes)
    gib  gibibytes (1024 mebibytes)
    tib  tebibytes (1024 gibibytes)
    pib  pebibytes (1024 tebibytes)
    eib  exbibytes (1024 pebibytes)
    zib  zebibytes (1024 exbibytes)
    yib  yobibytes (1024 zebibytes)

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

  local command='./euthanize --size 123kb'
  assert_output_equal "$USAGE"                                    "$command 2>/dev/null"
  assert_output_equal "\033[31mPath argument is required.\033[0m" "$command >/dev/null"

  rm -fr tmp
  mkdir tmp
  local command='./euthanize tmp --size 123yib'
  assert_output_equal "$USAGE"                                      "$command 2>/dev/null"
  assert_output_equal "\033[31mSize option is out of range.\033[0m" "$command >/dev/null"
  assert_exit_status_equal 1 "$command"
  rmdir tmp
}
arguments_missing_or_invalid_test
