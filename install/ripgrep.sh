#!/usr/bin/env bash

set -o nounset -o pipefail -o errexit

install() {
  if command -v brew > /dev/null 2>&1; then
    brew install ripgrep
  elif command -v apt-get > /dev/null 2>&1 && [[ "$(uname -m | tr "[:upper:]" "[:lower:]")" = "x86_64" ]]; then
    sudo apt-get install -y -qq ripgrep
  fi
}
