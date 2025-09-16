#!/usr/bin/env bash
# BashFlow Doc Generator
# License: GPLv3
# Author: Luis GuLo
# Version: 0.2

set -e

# ─────────────────────────────────────────────
# 🧭 Detección de la raíz del proyecto
PROJECT_ROOT="${BASHFLOW_HOME:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"

MODULE_PATHS=(
  "$PROJECT_ROOT/core/modules"
  "$PROJECT_ROOT/user_modules"
  "$PROJECT_ROOT/community_modules"
)

extract_metadata() {
  local file="$1"
  local module desc author version deps

  module=$(grep -m1 '^# Module:' "$file" | cut -d':' -f2- | xargs)
  desc=$(grep -m1 '^# Description:' "$file" | cut -d':' -f2- | xargs)
  author=$(grep -m1 '^# Author:' "$file" | cut -d':' -f2- | xargs)
  version=$(grep -m1 '^# Version:' "$file" | cut -d':' -f2- | xargs)
  deps=$(grep -m1 '^# Dependencies:' "$file" | cut -d':' -f2- | xargs)

  echo "📦 Module: $module"
  echo "🔧 Description: $desc"
  echo "👤 Author: $author"
  echo "📌 Version: $version"
  echo "📎 Dependencies: $deps"
  echo "—"
}

main() {
  echo "📚 BashFlow Modules Documentation"
  echo "================================="

  for dir in "${MODULE_PATHS[@]}"; do
    [ -d "$dir" ] || continue
    for file in "$dir"/*.sh; do
      [ -f "$file" ] && extract_metadata "$file"
    done
  done
}

main "$@"
