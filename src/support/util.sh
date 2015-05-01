# Utility functions.

# Display a message in red to stderr and exit with a nonzero status.
#
# Arguments:
#
# 1. no_newline -- if '-n' then no trailing line feed is displayed after the
#                  message; optional
# 2. message -- a failure message to be displayed in red to stderr
# 3. exit_status -- an exit status code; optional; defaults to 1
#
# Outputs:
#
# * stderr: the supplied message, formatted in red
#
# Exits: the supplied exit status or 1
fail() {
  if [ $# -gt 3 ]; then
    local message="$# for 1-3 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}"
    local formatted_message=$(format foreground_red "$message")
    say "$formatted_message" >&2
    exit -1
  fi

  local no_newline=false
  if [ "$1" == '-n' ]; then
    local no_newline=true
    shift
  fi

  local message="$1"
  shift

  local exit_status=1
  if [ $# -gt 0 ]; then
    local exit_status=$1
  fi

  local formatted_message=$(format foreground_red "$message")
  if [ $no_newline == true ]; then
    say -n "$formatted_message" >&2
  else
    say "$formatted_message" >&2
  fi
  exit $exit_status
}

# Format a string with xterm escape sequences. Valid formats are:
#
# * bold
# * underlined
# * blinking
# * inverse
# * foreground_black
# * foreground_red
# * foreground_green
# * foreground_yellow
# * foreground_blue
# * foreground_magenta
# * foreground_cyan
# * foreground_gray
# * foreground_default
# * background_black
# * background_red
# * background_green
# * background_yellow
# * background_blue
# * background_magenta
# * background_cyan
# * background_gray
# * background_default
#
# Arguments:
#
# 1...n-1. formats -- the format(s) to apply
# n. string -- the string to be formatted
#
# Outputs:
#
# * stdout: the supplied string, formatted as specified
format() {
  local codes=''
  while test $# -gt 1; do
    case "$1" in
      bold)
        local code=1
        ;;
      underlined)
        local code=4
        ;;
      blinking)
        local code=5
        ;;
      inverse)
        local code=7
        ;;
      foreground_black)
        local code=30
        ;;
      foreground_red)
        local code=31
        ;;
      foreground_green)
        local code=32
        ;;
      foreground_yellow)
        local code=33
        ;;
      foreground_blue)
        local code=34
        ;;
      foreground_magenta)
        local code=35
        ;;
      foreground_cyan)
        local code=36
        ;;
      foreground_gray)
        local code=37
        ;;
      foreground_default)
        local code=39
        ;;
      background_black)
        local code=40
        ;;
      background_red)
        local code=41
        ;;
      background_green)
        local code=42
        ;;
      background_yellow)
        local code=43
        ;;
      background_blue)
        local code=44
        ;;
      background_magenta)
        local code=45
        ;;
      background_cyan)
        local code=46
        ;;
      background_gray)
        local code=47
        ;;
      background_default)
        local code=49
        ;;
      *)
        local message="Invalid argument to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}: "
        local formatted_message=$(format foreground_red "$message")
        say -n "$formatted_message" >&2
        say -n "$(format underlined \"$1\")" >&2
        exit -1
        ;;
    esac
    if [ "$codes" != '' ]; then
      local codes="$codes;"
    fi
    local codes="$codes$code"
    shift
  done
  if [ "$codes" == '' ]; then
    printf "$1"
  else
    printf "\033[$codes"m"$1\033[0m"
  fi
}

# Execute one or more statements with an accompanying explanatory message and a
# confirmation or error message. If a statement has a nonzero exit status, return
# that status.
#
# Arguments:
#
# 1. message -- an explanatory message displayed before executing
# 2...n. statements -- statement(s) to be executed
#
# Assigns:
#
# * $result -- the stdout/stderr of the last statement executed
#
# Outputs:
#
# * stdout: the supplied message and a confirmation message
#
# Returns: the first nonzero status of a statement executed
inquire() {
  say -n "$1 ... "
  shift

  for statement in "$@"; do
    temp_function_for_inquire() {
      eval "$statement"
    }
    result="$(temp_function_for_inquire)"
    local status=$?
    if [ $status -ne 0 ]; then
      say "$(format foreground_red no)"
      return $status
    fi
  done

  say "$(format foreground_green yes)"
}

# Execute one or more statements with an accompanying explanatory message and a
# confirmation or error message. If a statement has a nonzero exit status, exit
# with that status.
#
# Arguments:
#
# 1. message -- an explanatory message displayed before executing
# 2...n. statements -- statement(s) to be executed
#
# Assigns:
#
# * $result -- the stdout/stderr of the last statement executed
#
# Outputs:
#
# * stdout: the supplied message and a confirmation message (upon success)
# * stderr: an error message (upon failure)
#
# Exits: the first nonzero status of a statement executed
perform() {
  say -n "$1 ... "
  shift

  for statement in "$@"; do
    with_temp_file stderr_file "
      temp_function_for_perform() {
        $statement
      }
      result=\"\$(temp_function_for_perform 2>\"\$stderr_file\")\"
      local status=\$?
      if [ \$status -ne 0 ] || [ -s \"\$stderr_file\" ]; then
        say -n \"\$(format foreground_red 'error!')\" >&2
        if [ -s \"\$stderr_file\" ]; then
          say \" -- \$(cat \"\$stderr_file\")\" >&2
        else
          say '' >&2
        fi
        exit \$status
      fi
    "
  done

  say "$(format foreground_green OK)"
}

# Display one or more messages.
#
# Arguments:
#
# 1. no_newline -- if '-n' then no trailing line feed is displayed after each of
#                  the supplied messages; optional
# 2...n. messages -- message(s) to be displayed
#
# Outputs:
#
# * stdout: the supplied message(s)
say() {
  local terminator="\n"
  if [ "$1" == '-n' ]; then
    local terminator=''
    shift
  fi

  for argument in "$@"; do
    printf "$argument$terminator"
  done
}

# Create a temporary file for the specified statements, automatically deleting it
# after executing them.
#
# Arguments:
#
# 1. file_path_variable -- the name of a variable that will be set to the name of
#                          the created temporary file
# 2...n. statements -- statement(s) to be executed after creation of a temporary
#                      file
#
# Outputs:
#
# * stdout/stderr: the output of supplied statement(s)
#
# Exits: the first nonzero status of a statement executed
#
# Returns: the status of the last statement executed
with_temp_file() {
  if [ $# -lt 2 ]; then
    printf "\033[31m$# for 2-n arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}\033[0m\n"
    exit -1
  fi

  local file_name_template="$(basename $0).$$.XXX"
  local file_name=$(mktemp -t "$file_name_template")
  local status=$?
  if [ $status -ne 0 ]; then
    printf "\033[31mFailed to create temporary file\033[0m"
    exit $status
  fi

  eval "$1=\"$file_name\""
  shift

  local status=0
  for script in "$@"; do
    temp_function_for_with_temp_file() {
      eval "$script"
    }
    temp_function_for_with_temp_file
    local status=$?
    if [ $status -ne 0 ]; then
      break
    fi
  done
  rm -f "$file_name" >/dev/null 2>&1
  return $status
}
