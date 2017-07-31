#!/usr/bin/env sh

set -e

for file in ${HOME}/code/dotfiles/symlinks/.*; do
  [ -r "${file}" ] && [ -f "${file}" ] && rm -f ${HOME}/`basename ${file}` && ln -s ${file} ${HOME}/`basename ${file}`
done