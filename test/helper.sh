#!/usr/bin/env sh

# Functions for asserting test conditions.

are_equal() {
  if [ $# -ne 2 ]; then
    printf "\033[31m$# for 2 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local expected="$1"
  local actual="$2"

  local file_name_template="$(basename $0).$$"

  local expected_file=$(mktemp -t "$file_name_template")
  local status=$?
  if [ $status -ne 0 ]; then
    printf "\033[31mFailed to create temporary file\033[0m"
    exit $status
  fi
  printf "$expected" >"$expected_file"

  local actual_file=$(mktemp -t "$file_name_template")
  local status=$?
  if [ $status -ne 0 ]; then
    printf "\033[31mFailed to create temporary file\033[0m"
    exit $status
  fi
  printf "$actual" >"$actual_file"

  diff "$expected_file" "$actual_file" >/dev/null 2>&1
  diff_status=$?

  rm -f "$expected_file" >/dev/null 2>&1
  rm -f "$actual_file" >/dev/null 2>&1

  return $diff_status
}

assert() {
  if [ $# -lt 1 ]; then
    printf "\033[31m$# for 1-2 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local value="$1"
  are_equal 0 "$value"
  if [ $? -ne 0 ]; then
    are_equal true "$value"
  fi
  if [ $? -eq 0 ]; then
    pass
  else
    local message="$2"
    fail "$message"
  fi
}

assert_equal() {
  if [ $# -lt 2 ]; then
    printf "\033[31m$# for 2-3 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local expected="$1"
  local actual="$2"
  local message="$3"
  if [ "$message" == '' ]; then
    local message="expected \"$expected\" but got \"$actual\""
  fi
  are_equal "$expected" "$actual"
  assert $? "$message"
}

assert_expression_equal() {
  if [ $# -lt 2 ]; then
    printf "\033[31m$# for 2-3 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local expected="$1"
  local expression="$2"
  local message="$3"
  printf "$expression ... "
  temp_function_for_assert_expression_equal() {
    eval "$expression"
  }
  result="$(temp_function_for_assert_expression_equal)"
  assert_equal "$expected" "$result" "$message"
}

deny() {
  if [ $# -lt 1 ]; then
    printf "\033[31m$# for 1-2 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local value="$1"
  are_equal 0 "$value"
  if [ $? -ne 0 ]; then
    are_equal true "$value"
  fi
  if [ $? -ne 0 ]; then
    pass
  else
    local message="$2"
    fail "$message"
  fi
}

deny_equal() {
  if [ $# -lt 2 ]; then
    printf "\033[31m$# for 2-3 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local unexpected="$1"
  local actual="$2"
  local message="$3"
  are_equal "$expected" "$actual"
  deny $? "did not expect \"$unexpected\"" "$message"
}

deny_expression_equal() {
  if [ $# -lt 2 ]; then
    printf "\033[31m$# for 2-3 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local unexpected="$1"
  local expression="$2"
  local message="$3"
  printf "$expression ... "
  local result=$($expression 2>&1)
  deny_equal "$unexpected" "$result" "$message"
}

fail() {
  local message="$1"
  if [ "$message" != '' ]; then
    message=" -- $message"
  fi
  printf "\033[31mFAIL\033[0m at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]} -> ${BASH_SOURCE[3]}:${BASH_LINENO[2]} -> ${BASH_SOURCE[4]}:${BASH_LINENO[3]}$message\n" >&2
  exit 1
}

pass() {
  local message="$1"
  if [ "$message" != '' ]; then
    message=" $message"
  fi
  printf "\033[32mPASS\033[0m$message\n"
}
