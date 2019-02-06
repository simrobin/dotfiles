#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

clean() {
  rm -rf \
    "${HOME}/.npm" \
    "${HOME}/.npm_packages" \
    "${HOME}/.babel.json" \
    "${HOME}/.node_repl_history" \
    "${HOME}/.v8flags."*
}

main() {
  clean

  if ! command -v git > /dev/null 2>&1; then
    echo "git not found"
    exit
  fi

  if ! command -v make > /dev/null 2>&1; then
    echo "make not found"
    exit
  fi

  rm -rf "${HOME}/n-install"
  git clone --depth 1 https://github.com/tj/n.git "${HOME}/n-install"
  pushd "${HOME}/n-install"
  PREFIX="${HOME}/opt" make install
  popd
  rm -rf "${HOME}/n-install"

  source "${SCRIPT_DIR}/../sources/n"
  n latest

  if command -v npm > /dev/null 2>&1; then
    npm install --ignore-scripts -g npm npm-check-updates node-gyp
  fi
}

main