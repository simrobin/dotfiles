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
    [[ -r ${file} ]] && [[ -f ${file} ]] && source "${file}"
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
