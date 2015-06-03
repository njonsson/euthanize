# Principal functions of the program.

compute_size_of() {
  if [ $# -ne 1 ]; then
    local message="$# for 1 argument supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}"
    local formatted_message=$(format foreground_red "$message")
    say "$formatted_message" >&2
    exit -1
  fi

  local path="$1"
  case "`uname`" in
    Darwin)
      say_verbose 'Detected Darwin platform.'
      local stat_args='-f %z'
      ;;
    Linux)
      say_verbose 'Detected Linux platform.'
      local stat_args="--format %s"
      ;;
    *)
      fail "`uname` is not supported."
      ;;
  esac
  find "$path" -type f -exec stat $stat_args "{}" \; 2>/dev/null | paste -sd+ - | bc
}

last_access_time_of() {
  if [ $# -ne 1 ]; then
    local message="$# for 1 argument supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}"
    local formatted_message=$(format foreground_red "$message")
    say "$formatted_message" >&2
    exit -1
  fi

  local path="$1"
  case "`uname`" in
    Darwin)
      say_verbose 'Detected Darwin platform.'
      local stat_args='-f %a'
      ;;
    Linux)
      say_verbose 'Detected Linux platform.'
      local stat_args='--format %X'
      ;;
    *)
      fail "`uname` is not supported."
      ;;
  esac

  date -j -f %s "$(stat $stat_args "$path")"
}

lru_file() {
  if [ $# -ne 0 ]; then
    local message="$# for 0 arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}"
    local formatted_message=$(format foreground_red "$message")
    say "$formatted_message" >&2
    exit -1
  fi

  case "`uname`" in
    Darwin)
      say_verbose 'Detected Darwin platform.'
      local stat_args='-f %a%t%N'
      ;;
    Linux)
      say_verbose 'Detected Linux platform.'
      local stat_args='--printf "%X\t%n"'
      ;;
    *)
      fail "`uname` is not supported."
      ;;
  esac

  find "$path" -type f -exec stat $stat_args "{}" \; | sort -n | head -1 | cut -f2-
}

# The program's entry point.
main() {
  set -o pipefail

  parse_options "$@"
  say_verbose 'Parsed options successfully.'

  while true; do
    say_verbose 'Computing actual size.'
    local actual_size=$(($(compute_size_of "$path")))
    say_verbose "Actual size is $actual_size byte(s)."

    if [ "$actual_size" -le "$size" ]; then
      say_verbose 'Actual size is not greater than size.'
      say_verbose 'Nothing left to do.'
      exit 0
    fi

    say_verbose 'Actual size is greater than size.'

    say_verbose 'Finding least-recently-accessed file.'
    local lru_file="$(lru_file)"

    say_verbose 'Obtaining size of least-recently-accessed file.'
    if [ $? -eq 0 ]; then
      local lru_size="$(compute_size_of "$lru_file")"

      say_verbose 'Obtaining last-access time of least-recently-accessed file.'
      local lru_time="$(last_access_time_of "$lru_file")"

      say_verbose "Found \`$lru_file' ($lru_size byte[s]), last accessed $lru_time."
    fi

    say "Deleting \`$lru_file'."
    rm -fr "$lru_file"
  done
}
