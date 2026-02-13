#!/usr/bin/env bash

[[ -z "${PS1:-}" ]] && return

set_locale() {
  local LOCALES=("en_US.UTF-8" "en_US.utf8" "C.UTF-8" "C")
  local ALL_LOCALES
  ALL_LOCALES="$(locale -a)"

  for locale in "${LOCALES[@]}"; do
    if [[ $(echo "${ALL_LOCALES}" | grep --count "${locale}") -eq 1 ]]; then
      export LC_ALL="${locale}"
      export LANG="${locale}"
      export LANGUAGE="${locale}"

      return
    fi
  done

  return 1
}

script_dir() {
  local FILE_SOURCE="${BASH_SOURCE[0]}"

  if [[ -L ${FILE_SOURCE} ]]; then
    dirname "$(readlink "${FILE_SOURCE}")"
  else
    (
      cd "$(dirname "${FILE_SOURCE}")" && pwd
    )
  fi
}

source_all() {
  local SCRIPT_DIR
  SCRIPT_DIR="$(script_dir)"

  for file in "${SCRIPT_DIR}/../sources/"*; do
    if [[ -r ${file} ]] && [[ -f ${file} ]]; then
      if [[ -n ${DOTFILES_PROFILE:-} ]]; then
        local start_time
        start_time=$(date +%s%N 2>/dev/null || gdate +%s%N 2>/dev/null || echo 0)
        source "${file}"
        local end_time
        end_time=$(date +%s%N 2>/dev/null || gdate +%s%N 2>/dev/null || echo 0)
        if [[ ${start_time} != "0" ]]; then
          printf "%6.1fms  %s\n" "$(echo "scale=1; (${end_time} - ${start_time}) / 1000000" | bc)" "${file##*/}" >&2
        fi
      else
        source "${file}"
      fi
    fi
  done

  var_color
}

set_locale
source_all

if [[ -e "${HOME}/.localrc" ]]; then
  source "${HOME}/.localrc"
fi

unset -f set_locale
unset -f script_dir
unset -f source_all
