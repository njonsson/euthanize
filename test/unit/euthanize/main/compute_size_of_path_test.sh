#!/usr/bin/env sh

source src/euthanize/main.sh
source test/helper.sh

compute_size_of_path_test() {
  rm -fr tmp
  mkdir tmp

  local expression='compute_size_of_path tmp'

  content_of_size 0 >tmp/0.txt
  assert_output_equal 0 "$expression"

  mkdir tmp/byte
  content_of_size 1 >tmp/byte/.1.txt
  assert_output_equal 1 "$expression"

  content_of_size 255 >"tmp/byte/255'.txt"
  assert_output_equal 256 "$expression"

  content_of_size 256 >'tmp/byte/"1.txt'
  assert_output_equal 512 "$expression"

  mkdir tmp/byte/.k
  content_of_size 1024 >'tmp/byte/.k/ 1.txt'
  assert_output_equal 1536 "$expression"

  rm -fr tmp
}
compute_size_of_path_test
