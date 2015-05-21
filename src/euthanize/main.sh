# Principal functions of the program.

compute_size() {
  local path="$1"
  case "`uname`" in
    Darwin)
      say_verbose 'Detected Darwin platform.'
      local stat_cmd='stat -f %z'
      ;;
    Linux)
      say_verbose 'Detected Linux platform.'
      local stat_cmd="stat --format %s"
      ;;
    *)
      fail "`uname` is not supported."
      ;;
  esac
  find "$path" -type f -exec $stat_cmd "{}" \; 2>/dev/null | paste -sd+ - | bc
}

delete_least_recently_accessed_file_from() {
  case "`uname`" in
    Darwin)
      say_verbose 'Detected Darwin platform.'
      local stat_cmd='stat -f %a%t%N'
      local cut_cmd='cut -f2-'
      ;;
    Linux)
      say_verbose 'Detected Linux platform.'
      local stat_cmd="stat --format '%X %n'"
      local cut_cmd="cut -d ' ' -f2-"
      ;;
    *)
      fail "`uname` is not supported."
      ;;
  esac

  # Using `local` always sets `$?` to 0, so work around that.
  _filename=$(find "$1" -type f -exec $stat_cmd "{}" \; | sort -n | head -1 | $cut_cmd)
  local status=$?
  local filename="$_filename"
  unset _filename

  if [ $status -ne 0 ]; then
    fail 'Failed to find files.'
  fi

  say "Removing $(format underlined "$filename") (NOT REALLY)"
  # rm "$filename"
}

# The program's entry point.
main() {
  set -o pipefail

  parse_options "$@"
  say_verbose 'Parsed options successfully.'

  say_verbose 'Computing actual size.'

  # Using `local` always sets `$?` to 0, so work around that.
  _actual_size=$(($(compute_size "$path")))
  local status=$?
  local actual_size="$_actual_size"
  unset _actual_size

  if [ $status -ne 0 ]; then
    fail "Failed to compute the size of \`$path'."
  fi

  say_verbose "Actual size is $actual_size bytes."

  if [ "$actual_size" -le "$size" ]; then
    say_verbose "Actual size is less than size."
    say 'Nothing to do.'
    exit 0
  fi
}
