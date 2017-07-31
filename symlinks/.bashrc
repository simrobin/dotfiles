#!/usr/bin/env sh

for file in ${HOME}/code/dotfiles/sources/*; do
  [ -r "${file}" ] && [ -f "${file}" ] && source ${file}
done