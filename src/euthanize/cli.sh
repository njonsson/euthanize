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
      '--verbose' | '-V')
        verbose=true
        ;;
      '--version' | '-v')
        say $VERSION
        exit
        ;;
      -*)
        complain_about_invalid_arguments "Option is not supported: \`$argument'."
        ;;
      *)
        if [ "$path" == '' ]; then
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

safely_multiply() {
  if [ $# -lt 2 ]; then
    local message="$# for 2-n arguments supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}"
    local formatted_message=$(format foreground_red "$message")
    say "$formatted_message" >&2
    exit -1
  fi

  local result="$1"
  shift
  for argument in "$@"; do
    local product=$((result*argument))
    local reverted="$((product/argument))"
    if [ "$reverted" == "$result" ]; then
      local result="$product"
    else
      say_verbose "Multiplying $result by $argument resulted in overflow."
      say 'Overflow'
      return 1
    fi
  done
  say "$result"
}

scale_size() {
  if [ $# -ne 1 ]; then
    local message="$# for 1 argument supplied to ${FUNCNAME}() at ${BASH_SOURCE[1]}:${BASH_LINENO[0]} -> ${BASH_SOURCE[2]}:${BASH_LINENO[1]}"
    local formatted_message=$(format foreground_red "$message")
    say "$formatted_message" >&2
    exit -1
  fi

  local size="$1"
  if [ "$size" == '' ]; then
    say 'Size option is required'
    return 1
  fi

  printf "$size" | grep --extended-regexp --silent '^[0-9]+$'
  if [ $? -eq 0 ]; then
    say "$size"
    return 0
  fi

  # Using `local` always sets `$?` to 0, so work around that.
  _scale=$(printf "$size" | grep --extended-regexp --ignore-case --only-match '[kmgtpezy]i?b$' | tr '[:upper:]' '[:lower:]')
  local status=$?
  local scale="$_scale"
  unset _scale

  if [ $status -ne 0 ]; then
    say 'Size option must be a valid size'
    return 1
  fi

  local size=$(printf "$size" | grep --extended-regexp --ignore-case --only-match '^[0-9]+')
  case "$scale" in
    kb)
      local size=$(safely_multiply "$size" 1000)
      ;;
    mb)
      local size=$(safely_multiply "$size" 1000 1000)
      ;;
    gb)
      local size=$(safely_multiply "$size" 1000 1000 1000)
      ;;
    tb)
      local size=$(safely_multiply "$size" 1000 1000 1000 1000)
      ;;
    pb)
      local size=$(safely_multiply "$size" 1000 1000 1000 1000 1000)
      ;;
    eb)
      local size=$(safely_multiply "$size" 1000 1000 1000 1000 1000 1000)
      ;;
    zb)
      local size=$(safely_multiply "$size" 1000 1000 1000 1000 1000 1000 1000)
      ;;
    yb)
      local size=$(safely_multiply "$size" 1000 1000 1000 1000 1000 1000 1000 1000)
      ;;
    kib)
      local size=$(safely_multiply "$size" 1024)
      ;;
    mib)
      local size=$(safely_multiply "$size" 1024 1024)
      ;;
    gib)
      local size=$(safely_multiply "$size" 1024 1024 1024)
      ;;
    tib)
      local size=$(safely_multiply "$size" 1024 1024 1024 1024)
      ;;
    pib)
      local size=$(safely_multiply "$size" 1024 1024 1024 1024 1024)
      ;;
    eib)
      local size=$(safely_multiply "$size" 1024 1024 1024 1024 1024 1024)
      ;;
    zib)
      local size=$(safely_multiply "$size" 1024 1024 1024 1024 1024 1024 1024)
      ;;
    yib)
      local size=$(safely_multiply "$size" 1024 1024 1024 1024 1024 1024 1024 1024)
      ;;
    *)
      say 'Size option must be a valid size'
      return 1
      ;;
  esac
  printf "$size" | grep --extended-regexp --silent '^[0-9]+$'
  if [ $? -ne 0 ]; then
    say 'Size option is out of range'
    return 1
  fi

  say "$size"
}

show_usage() {
  say 'Usage:'
  say ''
  say "`basename "$0"` --size SIZE PATH"
  say "`basename "$0"`  -s    SIZE PATH"
  say ''
  say '  Deletes files in PATH only if PATH is estimated to exceed SIZE, which is'
  say '  interpreted as a number of bytes. If SIZE includes a scale indicator, then it'
  say '  is scaled as:'
  say ''
  say '    kb   kilobytes (1000 bytes)'
  say '    mb   megabytes (1000 kilobytes)'
  say '    gb   gigabytes (1000 megabytes)'
  say '    tb   terabytes (1000 gigabytes)'
  say '    pb   petabytes (1000 terabytes)'
  say '    eb   exabytes (1000 petabytes)'
  say '    zb   zettabytes (1000 exabytes)'
  say '    yb   yottabytes (1000 zettabytes)'
  say ''
  say '    kib  kibibytes (1024 bytes)'
  say '    mib  mebibytes (1024 kibibytes)'
  say '    gib  gibibytes (1024 mebibytes)'
  say '    tib  tebibytes (1024 gibibytes)'
  say '    pib  pebibytes (1024 tebibytes)'
  say '    eib  exbibytes (1024 pebibytes)'
  say '    zib  zebibytes (1024 exbibytes)'
  say '    yib  yobibytes (1024 zebibytes)'
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

  say_verbose "Path is \`$path'."
}

validate_size() {
  # Using `local` always sets `$?` to 0, so work around that.
  _result=$(scale_size "$size")
  local status=$?
  local result="$_result"
  unset _result

  if [ $status -ne 0 ]; then
    complain_about_invalid_arguments "$result."
  fi

  size=$result

  say_verbose "Size is $size bytes."
}
