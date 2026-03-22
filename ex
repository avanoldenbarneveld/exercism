#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF'
Usage:
  ./ex new <exercise>
  ./ex test [exercise]
  ./ex submit [exercise]

Examples:
  ./ex new hello-world
  ./ex test hello-world
  ./ex submit hello-world

Notes:
  - If you omit the exercise, ./ex uses the current folder.
  - Exercise names default to the javascript track.
  - For another track, use track/exercise, for example:
    ./ex test typescript/hello-world
EOF
}

exercise_dir() {
  if [[ -n "${1:-}" ]]; then
    if [[ "$1" == */* ]]; then
      echo "$ROOT/$1"
    else
      echo "$ROOT/javascript/$1"
    fi
  else
    pwd
  fi
}

install_if_needed() {
  local dir="$1"

  if [[ -d "$dir/node_modules" || -f "$dir/.pnp.cjs" || -f "$dir/.yarn/install-state.gz" ]]; then
    return
  fi

  echo "Installing dependencies in ${dir#$ROOT/}..."
  if [[ -f "$dir/pnpm-lock.yaml" ]]; then
    (cd "$dir" && corepack pnpm install)
  elif [[ -f "$dir/yarn.lock" || -f "$dir/.yarnrc.yml" ]]; then
    (cd "$dir" && corepack yarn install)
  else
    (cd "$dir" && npm install)
  fi
}

submit_files() {
  find "$1" -maxdepth 1 -type f \
    \( -name '*.js' -o -name '*.ts' \) \
    ! -name '*.spec.*' \
    ! -name '*.test.*' \
    ! -name 'global.d.ts' \
    -exec basename {} \; | sort
}

cmd="${1:-help}"
arg="${2:-}"

case "$cmd" in
  new)
    [[ -n "$arg" ]] || { usage; exit 1; }
    echo "Downloading javascript/$arg..."
    (cd "$ROOT/javascript" && exercism download --track=javascript --exercise="$arg")
    install_if_needed "$(exercise_dir "$arg")"
    ;;
  test)
    dir="$(exercise_dir "$arg")"
    install_if_needed "$dir"
    (cd "$dir" && npm test)
    ;;
  submit)
    dir="$(exercise_dir "$arg")"
    mapfile -t files < <(submit_files "$dir")
    [[ "${#files[@]}" -gt 0 ]] || { echo "No solution file found."; exit 1; }
    (cd "$dir" && exercism submit "${files[@]}")
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    usage
    exit 1
    ;;
esac
