#!/usr/bin/env sh

source src/support.sh
source test/helper.sh

with_temp_file_test() {
  local file_name_template="$(basename $0).$$.XXX"

  local stdout_file=$(mktemp -t "$file_name_template")
  local status=$?
  if [ $status -ne 0 ]; then
    printf "\033[31mFailed to create temporary file\033[0m"
    exit $status
  fi

  local stderr_file=$(mktemp -t "$file_name_template")
  local status=$?
  if [ $status -ne 0 ]; then
    printf "\033[31mFailed to create temporary file\033[0m"
    exit $status
  fi

  source_executed=false
  file_exists=false
  with_temp_file my_temp_file "
    source_executed=true
    if [ -f \"\$my_temp_file\" ]; then
      file_exists=true
    fi
    printf \"Written to temporary file\\n\" >\"\$my_temp_file\"
    printf \"Written to stdout\\n\"
    printf \"Written to stderr\\n\" >&2

    return 123

    printf \"Not written to temporary file\\n\" >\"\$my_temp_file\"
    printf \"Not written to stdout\\n\"
    printf \"Not written to stderr\\n\" >&2
  " >"$stdout_file" 2>"$stderr_file"
  local status=$?
  local stdout=$(cat "$stdout_file")
  rm -f "$stdout_file" &>/dev/null
  local stderr=$(cat "$stderr_file")
  rm -f "$stderr_file" &>/dev/null

  assert "$source_executed" 'Source was not executed as expected'
  assert "$file_exists" 'Temporary file was not created as expected'
  assert_equal 123 $status 'Status was not passed as expected'
  assert_equal 'Written to stdout' "$stdout" 'stdout was not written as expected'
  assert_equal 'Written to stderr' "$stderr" 'stderr was not written as expected'
  if [ -f "$my_temp_file" ]; then
    fail "Temporary file $my_temp_file was not deleted as expected"
  else
    pass
  fi
}
with_temp_file_test
