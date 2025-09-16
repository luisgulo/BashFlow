#!/bin/bash
# BashFlow Module Documentation Generator
# License: GPLv3
# Author: Luis GuLo
# Version: 1.0

OUTPUT="docs/modules-list.md"
MODULE_DIRS=("core/modules" "user_modules" "community_modules")

echo "# 🧩 Módulos en BashFlow" > "$OUTPUT"
echo "" >> "$OUTPUT"
echo "**Generado automáticamente el $(date '+%Y-%m-%d %H:%M:%S')**" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "| Módulo | Descripción | Autor | Versión | Dependencias |" >> "$OUTPUT"
echo "|--------|-------------|-------|---------|---------------|" >> "$OUTPUT"

for dir in "${MODULE_DIRS[@]}"; do
  [ -d "$dir" ] || continue
  for file in "$dir"/*.sh; do
    name=$(basename "$file" .sh)
    desc=$(grep -E '^# Description:' "$file" | sed 's/^# Description:[[:space:]]*//')
    author=$(grep -E '^# Author:' "$file" | sed 's/^# Author:[[:space:]]*//')
    version=$(grep -E '^# Version:' "$file" | sed 's/^# Version:[[:space:]]*//')
    deps=$(grep -E '^# Dependencies:' "$file" | sed 's/^# Dependencies:[[:space:]]*//')

    echo "| $name | $desc | $author | $version | $deps |" >> "$OUTPUT"
  done
done

echo "" >> "$OUTPUT"
echo "_Para actualizar esta tabla, ejecuta: \`core/utils/module-docgen.sh\`_" >> "$OUTPUT"

echo "✅ Documentación generada en $OUTPUT"
