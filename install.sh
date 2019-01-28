#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
  printf '+----------+\n'
  printf '| symlinks |\n'
  printf '+----------+\n'
  for file in "${SCRIPT_DIR}/symlinks"/*; do
    basenameFile=$(basename "${file}")
    [ -r "${file}" ] && [ -e "${file}" ] && rm -f "${HOME}/.${basenameFile}" && ln -s "${file}" "${HOME}/.${basenameFile}"
  done

  set +u
  set +e
  PS1='$' source "${HOME}/.bashrc"
  set -e
  set -u

  local line='--------------------------------------------------------------------------------'

  for file in "${SCRIPT_DIR}/install"/*; do
    local basenameFile=$(basename ${file%.*})
    printf "%s%s%s\n" "+-" "${line:0:${#basenameFile}}" "-+"
    printf "%s%s%s\n" "| " ${basenameFile} " |"
    printf "%s%s%s\n" "+-" "${line:0:${#basenameFile}}" "-+"

    [ -r "${file}" ] && [ -x "${file}" ] && "${file}"
  done

  printf '+-------+\n'
  printf '| clean |\n'
  printf '+-------+\n'
  if [[ "${IS_MACOS}" == true ]]; then
    brew cleanup
  elif command -v apt-get > /dev/null 2>&1; then
    sudo apt-get autoremove -y
    sudo apt-get clean all
  fi
}

main
