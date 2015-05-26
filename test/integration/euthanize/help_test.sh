#!/usr/bin/env sh

source test/helper.sh

help_test() {
  local HELP='Deletes least-recently-used files in a directory.

Usage:

euthanize --version
euthanize  -v

  Displays the current version of euthanize.

euthanize --help
euthanize  -h

  Displays this help message.

euthanize [--verbose] --size SIZE PATH
euthanize  [-V]        -s    SIZE PATH

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

  local command='./euthanize --help'
  assert_output_equal "$HELP" "$command"
  assert_exit_status_equal 0 "$command"

  local command='./euthanize -h'
  assert_output_equal "$HELP" "$command"
  assert_exit_status_equal 0 "$command"
}
help_test
