#!/usr/bin/env bash

[[ -z "${PS1:-}" ]] && return

readonly BASHRC_PATH=$(python -c 'import sys; import os.path; print(os.path.realpath(sys.argv[1]))' "${BASH_SOURCE[0]}")
readonly DOTFILES_PATH="$(dirname ${BASHRC_PATH})/.."

# Setting locale for having correct sort of filename in sources/
if [[ $(locale -a | grep "en_US.UTF-8" | wc -l) -eq 1 ]]; then
  export LC_ALL="en_US.UTF-8"
  export LANG="en_US.UTF-8"
  export LANGUAGE="en_US.UTF-8"
elif [[ $(locale -a | grep "C.UTF-8" | wc -l) -eq 1 ]]; then
  export LC_ALL="C.UTF-8"
  export LANG="C.UTF-8"
  export LANGUAGE="C.UTF-8"
fi

for file in "${DOTFILES_PATH}/sources/"*; do
  [[ -r "${file}" ]] && [[ -f "${file}" ]] && source "${file}"
done

if [[ -e "${HOME}/.localrc" ]]; then
  source "${HOME}/.localrc"
fi
