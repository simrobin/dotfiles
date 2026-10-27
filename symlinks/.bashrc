#!/usr/bin/env bash
# shellcheck disable=SC1090 # sources/ files and ~/.local*rc files are runtime paths

# Two tiers. The environment tier (locale, PATH, exports, secrets, mise shims)
# loads in every shell, interactive or not, so that non-interactive shells (scp,
# rsync, stdio MCP servers started from a login shell) see the
# same variables as a terminal. The interactive tier (prompt, aliases,
# completions, prompt hooks) only loads behind the PS1 guard.
# Nothing before the guard may write to stdout or stderr.

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
  local SOURCE_DIR="${1}"

  for file in "${SOURCE_DIR}/"*; do
    if [[ -r ${file} ]] && [[ -f ${file} ]]; then
      if [[ -n ${DOTFILES_PROFILE:-} ]]; then
        local start_time
        start_time=$(date +%s%N 2>/dev/null || gdate +%s%N 2>/dev/null || echo 0)
        source "${file}"
        local end_time
        end_time=$(date +%s%N 2>/dev/null || gdate +%s%N 2>/dev/null || echo 0)
        if [[ ${start_time} != "0" ]]; then
          printf "%6.1fms  %s\n" "$(echo "scale=1; (${end_time} - ${start_time}) / 1000000" | bc)" "${file##*/}" >&2
        fi
      else
        source "${file}"
      fi
    fi
  done
}

SOURCES_DIR="$(script_dir)"
SOURCES_DIR="${SOURCES_DIR}/../sources"

# Environment tier: silent files only (exports and PATH, no prompt hook)
set_locale
source_all "${SOURCES_DIR}/env"

if [[ -e "${HOME}/.local_envrc" ]]; then
  source "${HOME}/.local_envrc"
fi

# Deduplicate PATH entries (preserves order, first occurrence wins): a nested
# shell inherits PATH and runs this tier again
PATH="$(printf '%s' "${PATH}" | awk -v RS=: -v ORS=: '!seen[$0]++')"
PATH="${PATH%:}"
export PATH

# Last on purpose: mise's shims must front everything, including what
# .local_envrc prepends. The prompt hook of `mise activate bash` does not run
# outside a terminal, while a shim resolves the per-project version at call
# time and falls through to the PATH binary (`n`'s node, for example) when no
# mise config applies. Idempotent: prints nothing when the shims already lead.
if command -v mise > /dev/null 2>&1; then
  eval "$(mise activate bash --shims)"
fi

unset -f set_locale
unset -f script_dir

if [[ -z "${PS1:-}" ]]; then
  unset -f source_all
  unset SOURCES_DIR
  return
fi

# Interactive tier
source_all "${SOURCES_DIR}"
var_color

if [[ -e "${HOME}/.localrc" ]]; then
  source "${HOME}/.localrc"
fi

# The prompt hook keeps the tool paths in sync with the current directory
if command -v mise > /dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

unset -f source_all
unset SOURCES_DIR
