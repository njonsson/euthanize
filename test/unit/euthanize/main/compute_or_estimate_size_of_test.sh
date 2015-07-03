#!/usr/bin/env sh

source src/euthanize/main.sh
source src/support.sh
source test/helper.sh

compute_or_estimate_size_of_test() {
  rm -fr tmp
  mkdir tmp

  local expression='compute_or_estimate_size_of tmp'

  content_of_size 0 >tmp/0.txt
  assert_output_equal 0 "$expression"

  mkdir tmp/byte
  content_of_size 1 >tmp/byte/.1.txt
  assert_output_equal 1 "$expression"

  content_of_size 1 >tmp/byte/1-again.txt
  assert_output_equal 2 "$expression"

  content_of_size 255 >"tmp/byte/255'.txt"
  assert_output_equal 257 "$expression"

  content_of_size 256 >'tmp/byte/"1.txt'
  assert_output_equal 513 "$expression"

  mkdir tmp/byte/.k
  content_of_size 1024 >'tmp/byte/.k/ 1.txt'
  assert_output_equal 1537 "$expression"

  mkdir tmp/byte/mb
  content_of_size 16384 >'tmp/byte/mb/16.txt'
  assert_output_equal 17921 "$expression"

  content_of_size 25600 >'tmp/byte/mb/25'
  assert_output_equal 65536 "$expression" # Estimate; exact is 43521.

  rm -fr tmp
}
compute_or_estimate_size_of_test
