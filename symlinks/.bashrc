#!/usr/bin/env bash

[[ -z "${PS1:-}" ]] && return

readonly BASHRC_PATH=$(python -c 'import sys; import os.path; print(os.path.realpath(sys.argv[1]))' "${BASH_SOURCE[0]}")
readonly DOTFILES_PATH="$(dirname ${BASHRC_PATH})/.."

for file in "${DOTFILES_PATH}/sources/"*; do
  [[ -r "${file}" ]] && [[ -f "${file}" ]] && source "${file}"
done

if [[ -e "${HOME}/.localrc" ]]; then
  source "${HOME}/.localrc"
fi
