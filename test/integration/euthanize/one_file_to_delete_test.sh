#!/usr/bin/env sh

source test/helper.sh

one_file_to_delete_test() {
  content_of_size 1 >1.txt
  assert_file_exists '1.txt'
  local command='./euthanize --size 0 1.txt'
  assert_output_equal "Deleting \`1.txt'." "$command"
  deny_file_exists '1.txt'
  content_of_size 1 >1.txt
  assert_exit_status_equal 0 "$command"
  rm -f 1.txt

  rm -fr tmp
  mkdir tmp

  content_of_size 1 >tmp/1.txt
  assert_file_exists 'tmp/1.txt'
  touch -at 201506030855 tmp/1.txt

  content_of_size 2 >tmp/2.txt
  assert_file_exists 'tmp/2.txt'
  touch -at 201506030854 tmp/2.txt

  local command='./euthanize --size 2 tmp'
  assert_output_equal "Deleting \`tmp/2.txt'." "$command"
  assert_file_exists 'tmp/1.txt'
  deny_file_exists   'tmp/2.txt'
  assert_exit_status_equal 0 "$command"

  rm -fr tmp
  mkdir tmp

  content_of_size 1 >tmp/1.txt
  assert_file_exists 'tmp/1.txt'
  touch -at 201506030854 tmp/1.txt

  content_of_size 2 >tmp/2.txt
  assert_file_exists 'tmp/2.txt'
  touch -at 201506030855 tmp/2.txt

  local command='./euthanize --size 2 tmp'
  assert_output_equal "Deleting \`tmp/1.txt'." "$command"
  deny_file_exists   'tmp/1.txt'
  assert_file_exists 'tmp/2.txt'
  assert_exit_status_equal 0 "$command"

  rm -fr tmp
}
one_file_to_delete_test
