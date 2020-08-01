#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

clean() {
  rm -rf "${HOME}/.fzf.bash"
  rm -rf "${HOME}/opt/fzf"
}

install() {
  if ! command -v git >/dev/null 2>&1; then
    printf "git not found\n"
    exit
  fi

  local FZF_INSTALL_DIR="${HOME}/opt/fzf"

  if [[ ! -d ${FZF_INSTALL_DIR} ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "${FZF_INSTALL_DIR}"
  else
    (cd "${FZF_INSTALL_DIR}" && git pull)
  fi

  "${FZF_INSTALL_DIR}/install" --key-bindings --completion --no-zsh --no-fish --no-update-rc
}
