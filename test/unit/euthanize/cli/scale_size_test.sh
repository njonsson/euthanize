#!/usr/bin/env sh

source src/euthanize/cli.sh
source src/support.sh
source test/helper.sh

scale_size_test() {
  local expression='scale_size ""'
  assert_output_equal 'Size option is required' "$expression"
  assert_exit_status_equal 1 "$expression"


  local expression='scale_size "foo"'
  assert_output_equal 'Size option must be a valid size' "$expression"
  assert_exit_status_equal 1 "$expression"

  local expression='scale_size "1x"'
  assert_output_equal 'Size option must be a valid size' "$expression"
  assert_exit_status_equal 1 "$expression"


  local expression='scale_size 123'
  assert_output_equal 123 "$expression"
  assert_exit_status_equal 0 "$expression"


  local expression='scale_size 123kb'
  assert_output_equal 123000 "$expression"
  assert_exit_status_equal 0 "$expression"

  local expression='scale_size 123MB'
  assert_output_equal 123000000 "$expression"
  assert_exit_status_equal 0 "$expression"

  local expression='scale_size 123Gb'
  assert_output_equal 123000000000 "$expression"
  assert_exit_status_equal 0 "$expression"

  local expression='scale_size 123tb'
  assert_output_equal 123000000000000 "$expression"
  assert_exit_status_equal 0 "$expression"

  local expression='scale_size 123pb'
  deny_output_equal 'Size option must be a valid size' "$expression"

  local expression='scale_size "123eb"'
  deny_output_equal 'Size option must be a valid size' "$expression"

  local expression='scale_size "123zb"'
  assert_output_equal 'Size option is out of range' "$expression"
  assert_exit_status_equal 1 "$expression"

  local expression='scale_size "123yb"'
  assert_output_equal 'Size option is out of range' "$expression"
  assert_exit_status_equal 1 "$expression"


  local expression='scale_size 123kib'
  assert_output_equal 125952 "$expression"
  assert_exit_status_equal 0 "$expression"

  local expression='scale_size 123MiB'
  assert_output_equal 128974848 "$expression"
  assert_exit_status_equal 0 "$expression"

  local expression='scale_size 123Gib'
  assert_output_equal 132070244352 "$expression"
  assert_exit_status_equal 0 "$expression"

  local expression='scale_size 123tib'
  assert_output_equal 135239930216448 "$expression"
  assert_exit_status_equal 0 "$expression"

  local expression='scale_size 123pib'
  deny_output_equal 'Size option must be a valid size' "$expression"

  local expression='scale_size "123eib"'
  deny_output_equal 'Size option must be a valid size' "$expression"

  local expression='scale_size "123zib"'
  assert_output_equal 'Size option is out of range' "$expression"
  assert_exit_status_equal 1 "$expression"

  local expression='scale_size "123yib"'
  assert_output_equal 'Size option is out of range' "$expression"
  assert_exit_status_equal 1 "$expression"
}
scale_size_test
