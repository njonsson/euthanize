# Principal functions of the program.

delete_least_recently_accessed_file_from() {
  case "`uname`" in
    Darwin)
      local stat_cmd='stat -f %a%t%N'
      local cut_cmd='cut -f2-'
      ;;
    Linux)
      local stat_cmd="stat --format '%X %n'"
      local cut_cmd="cut -d ' ' -f2-"
      ;;
    *)
      fail "`uname` is not supported"
      ;;
  esac
  local filename=$(find "$1" -type f -exec $stat_cmd "{}" \; | sort -n | head -1 | $cut_cmd)
  if [ $? -ne 0 ]; then
    fail 'Failed to find files'
  fi

  say "Removing $(format underlined "$filename") (NOT REALLY)"
  # rm "$filename"
}

# The program's entry point.
main() {
  parse_options "$@"
  delete_least_recently_accessed_file_from "$path"
}
