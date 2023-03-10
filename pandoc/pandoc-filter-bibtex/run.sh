#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1

if command -v nix &>/dev/null; then
  . <(nix print-dev-env)
  exec pandoc-filter-bibtex
fi

exec stack run
