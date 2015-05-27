#!/usr/bin/env sh

source test/helper.sh

nothing_to_do_test() {
  content_of_size 0 >0.txt
  assert_file_exists '0.txt'
  local command='./euthanize --size 0 0.txt'
  assert_output_equal 'Nothing to do.' "$command"
  assert_exit_status_equal 0 "$command"
  assert_file_exists '0.txt'
  rm 0.txt

  content_of_size 4 >4.txt
  assert_file_exists '4.txt'
  local command='./euthanize --size 8 4.txt'
  assert_output_equal 'Nothing to do.' "$command"
  assert_exit_status_equal 0 "$command"
  assert_file_exists '4.txt'
  rm 4.txt

  rm -fr tmp
  mkdir tmp

  content_of_size 0 >tmp/0.txt
  assert_file_exists 'tmp/0.txt'

  local command='./euthanize --size 0 tmp'
  assert_output_equal 'Nothing to do.' "$command"
  assert_exit_status_equal 0 "$command"
  assert_file_exists 'tmp/0.txt'

  local command='./euthanize --size 1 tmp'
  assert_output_equal 'Nothing to do.' "$command"
  assert_exit_status_equal 0 "$command"
  assert_file_exists 'tmp/0.txt'

  mkdir tmp/byte
  content_of_size 1 >tmp/byte/1-byte.txt
  assert_file_exists 'tmp/byte/1-byte.txt'

  local command='./euthanize --size 1 tmp'
  assert_output_equal 'Nothing to do.' "$command"
  assert_exit_status_equal 0 "$command"
  assert_file_exists 'tmp/0.txt'
  assert_file_exists 'tmp/byte/1-byte.txt'

  mkdir tmp/byte/kb
  content_of_size 1000 >tmp/byte/kb/1-kb.txt
  assert_file_exists 'tmp/byte/kb/1-kb.txt'

  local command='./euthanize --size 2KB tmp'
  assert_output_equal 'Nothing to do.' "$command"
  assert_exit_status_equal 0 "$command"
  assert_file_exists 'tmp/0.txt'
  assert_file_exists 'tmp/byte/1-byte.txt'
  assert_file_exists 'tmp/byte/kb/1-kb.txt'

  rm -fr tmp
}
nothing_to_do_test
