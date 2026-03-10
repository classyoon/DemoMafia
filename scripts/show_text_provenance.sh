#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

show_file_provenance() {
  local file="$1"
  local absolute_file="$ROOT_DIR/$file"

  echo "=================================================="
  echo "FILE: $file"
  echo "=================================================="
  echo

  echo "[History]"
  git -C "$ROOT_DIR" log --follow --pretty=format:'%h %ad %an %s' --date=short -- "$file"
  echo
  echo

  local first_commit
  first_commit="$(git -C "$ROOT_DIR" log --follow --reverse --format='%h' -- "$file" | head -n 1)"

  if [[ -n "${first_commit:-}" ]]; then
    echo "[Original committed content @ $first_commit]"
    git -C "$ROOT_DIR" show "${first_commit}:${file}"
    echo
    echo
  fi

  echo "[Current working tree content]"
  cat "$absolute_file"
  echo
  echo

  echo "[Working tree diff vs HEAD]"
  git -C "$ROOT_DIR" diff -- "$file" || true
  echo
}

show_file_provenance "DemoMafia/JSON/AppText.json"
show_file_provenance "DemoMafia/JSON/GameText.json"
