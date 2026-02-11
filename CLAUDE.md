# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository (inspired by [ViBiOh/dotfiles](https://github.com/ViBiOh/dotfiles)) managing shell configuration, tool installation, and system setup for macOS/Linux.

## Architecture

The repo has three main directories:

- **`symlinks/`** — Config files (`.bashrc`, `.gitconfig`, etc.) that get symlinked into `$HOME`
- **`sources/`** — Shell scripts sourced by `.bashrc`, ordered by numeric prefix (`_01_first` through `_07_ssh`) then alphabetically. These provide env vars, functions, aliases, completions, and the PS1 prompt.
- **`install/`** — Modular install scripts, each defining `install()`, `clean()`, and/or `credentials()` functions. Prefixed scripts (`_clean`, `_hosts`, `_macos`, `_packages`) handle cross-cutting concerns.


## Setup & Commands

```bash
# Full setup (symlinks + clean + install + credentials)
./init

# Run specific stage(s)
./init symlinks
./init install
./init clean
./init credentials

# Limit to a single install script
./init -l node install
./init -l golang install

# Skip a tool via env var (uppercase filename)
DOTFILES_NO_NODE="true" ./init
```

## Key Conventions

- **Install scripts** must define functions (`install`, `clean`, `credentials`) — the `init` script sources each file and calls the functions if they exist.
- **Source scripts** are loaded in sort order by `.bashrc`. Numeric prefixes ensure dependencies load first (e.g., `_02_var` provides `var_read`/`var_log` helpers used by everything else).
- **Symlink strategy**: files in `symlinks/` are symlinked to `$HOME` as-is. Old symlinks are removed before re-creating.
- **Shell style**: `set -o nounset -o pipefail -o errexit` in scripts. Helper functions from `sources/_02_var` (`var_read`, `var_color`, `var_log`, `var_info`, `var_warning`, `var_success`, `var_error`) are available in install scripts.
- **Package management**: `sources/_05_packages` abstracts `brew`/`apt` behind `packages_install`, `packages_clean`, etc.
