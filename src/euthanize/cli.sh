# Functions for program user interaction.

complain_about_invalid_arguments() {
  local reason="$1"
  if [ "$reason" == '' ]; then
    local reason='One ore more arguments are invalid.'
  fi
  local reason=$(format foreground_red "$reason")
  say "$reason\n" >&2
  show_usage
  exit 1
}

parse_options() {
  local set_size=false
  for argument in "$@"; do
    if [ $set_size == true ]; then
      size="$argument"
      local set_size=false
      continue
    fi

    case "$argument" in
      '--help' | '-h')
        say 'Deletes least-recently-used files in a directory.'
        say ''
        show_usage
        exit
        ;;
      '--size' | '-s')
        local set_size=true
        ;;
      '--version' | '-v')
        say $VERSION
        exit
        ;;
      '')
        complain_about_invalid_arguments
        ;;
      *)
        if [ "$path" = '' ]; then
          path="$argument"
        else
          complain_about_invalid_arguments 'More than one path argument was specified.'
        fi
        ;;
    esac
  done
  validate_size
  validate_path
}

show_usage() {
  say 'Usage:'
  say ''
  say "`basename "$0"` --size SIZE PATH"
  say "`basename "$0"`  -s    SIZE PATH"
  say ''
  say '  Deletes files in PATH only if PATH is estimated to exceed SIZE, which is'
  say '  interpreted as a number of 512-byte blocks. If SIZE is followed by a scale'
  say '  indicator, then it is scaled as:'
  say ''
  say '    kb  kilobytes (1024 bytes)'
  say '    mb  megabytes (1024 kilobytes)'
  say '    gb  gigabytes (1024 megabytes)'
  say '    tb  terabytes (1024 gigabytes)'
  say '    pb  petabytes (1024 terabytes)'
  say ''
  say '  PATH must be an existing directory or regular file.'
}

validate_path() {
  if [ "$path" == '' ]; then
    complain_about_invalid_arguments 'Path argument is required.'
  fi

  if [ ! -d "$path" ]; then
    if [ ! -f "$path" ]; then
      complain_about_invalid_arguments 'Path argument must be an existing directory or file.'
    fi
  fi
}

validate_size() {
  if [ "$size" == '' ]; then
    complain_about_invalid_arguments 'Size option is required.'
  fi

  printf "$size" | grep --extended-regexp --ignore-case '^[0-9]+([kmgtp]b)?$' >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    complain_about_invalid_arguments 'Size option must be a valid size.'
  fi
}
