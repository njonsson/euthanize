#!/usr/bin/env sh

# Functions for asserting test conditions.

are_equal() {
  if [ $# -ne 2 ]; then
    printf "\033[31m$# for 2 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local expected="$1"
  local actual="$2"

  local file_name_template="$(basename $0).$$.XXX"

  # Using `local` always sets `$?` to 0, so work around that.
  _expected_file=$(mktemp -t "$file_name_template")
  local status=$?
  local expected_file="$_expected_file"
  unset _expected_file

  if [ $status -ne 0 ]; then
    printf "\033[31mFailed to create temporary file\033[0m"
    exit $status
  fi
  printf "$expected" >"$expected_file"

  # Using `local` always sets `$?` to 0, so work around that.
  _actual_file=$(mktemp -t "$file_name_template")
  local status=$?
  local actual_file="$_actual_file"
  unset _actual_file

  if [ $status -ne 0 ]; then
    printf "\033[31mFailed to create temporary file\033[0m"
    exit $status
  fi
  printf "$actual" >"$actual_file"

  diff "$expected_file" "$actual_file" &>/dev/null
  diff_status=$?

  rm -f "$expected_file" "$actual_file" &>/dev/null

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

assert_exit_status_equal() {
  if [ $# -lt 2 ]; then
    printf "\033[31m$# for 2-3 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local expected="$1"
  local expression="$2"
  local message="$3"
  printf "$expression ... "
  temp_function_for_assert_exit_status_equal() {
    eval "$expression" &>/dev/null
  }
  temp_function_for_assert_exit_status_equal
  assert_equal "$expected" "$?" "$message"
}

assert_file_exists() {
  if [ $# -lt 1 ]; then
    printf "\033[31m$# for 1-2 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local path="$1"
  local message="$2"
  if [ "$message" == '' ]; then
    message="file \`$path' does not exist"
  fi
  printf "$path exists ... "
  if [ -f "$path" ]; then
    pass
  else
    fail "$message"
  fi
}

assert_output_equal() {
  if [ $# -lt 2 ]; then
    printf "\033[31m$# for 2-3 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local expected="$1"
  local expression="$2"
  local message="$3"
  printf "$expression ... "
  temp_function_for_assert_output_equal() {
    eval "$expression" 2>&1
  }
  result="$(temp_function_for_assert_output_equal)"
  assert_equal "$expected" "$result" "$message"
}

content_of_size() {
  if [ $# -lt 1 ]; then
    printf "\033[31m$# for 1 argument supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local size=$(($1))
  if [ "$size" -lt 0 ]; then
    printf "\033[31millegal negative size argument supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  if [ "$size" -gt 0 ]; then
    for i in $(seq $size); do
      printf x
    done
  fi
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

deny_exit_status_equal() {
  if [ $# -lt 2 ]; then
    printf "\033[31m$# for 2-3 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local expected="$1"
  local expression="$2"
  local message="$3"
  printf "$expression ... "
  temp_function_for_deny_exit_status_equal() {
    eval "$expression" &>/dev/null
  }
  temp_function_for_deny_exit_status_equal
  deny_equal "$expected" "$?" "$message"
}

deny_file_exists() {
  if [ $# -lt 1 ]; then
    printf "\033[31m$# for 1-2 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local path="$1"
  local message="$2"
  if [ "$message" == '' ]; then
    message="file \`$path' exists"
  fi
  printf "$path does not exist ... "
  if [ -f "$path" ]; then
    fail "$message"
  else
    pass
  fi
}

deny_output_equal() {
  if [ $# -lt 2 ]; then
    printf "\033[31m$# for 2-3 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local unexpected="$1"
  local expression="$2"
  local message="$3"
  printf "$expression ... "
  temp_function_for_deny_output_equal() {
    eval "$expression" 2>&1
  }
  result="$(temp_function_for_deny_output_equal)"
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
