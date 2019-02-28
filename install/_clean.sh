#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

main() {
  if [[ "${DOTFILES_CLEAN:-}" = "true" ]]; then
    rm -rf "${HOME}/opt"
    mkdir -p "${HOME}/opt/bin"
  fi
}

main
