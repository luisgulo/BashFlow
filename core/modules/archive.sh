#!/usr/bin/env bash
# Module: archive
# Description: Comprime, descomprime y extrae archivos en remoto (tar, zip, gzip, bzip2)
# License: GPLv3
# Author: Luis GuLo
# Version: 1.0
# Dependencies: ssh, tar, gzip, bzip2, zip, unzip

archive_task() {
  local host="$1"; shift
  declare -A args
  local files=()

  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    if [[ "$key" == "files" ]]; then
      IFS=',' read -r -a files <<< "$value"
    else
      args["$key"]="$value"
    fi
  done

  local action="${args[action]}"
  local format="${args[format]:-tar}"
  local output="${args[output]}"
  local archive="${args[archive]}"
  local dest="${args[dest]:-$(dirname "$archive")}"
  local become="${args[become]}"
  local prefix=""
  [ "$become" = "true" ] && prefix="sudo"

  case "$action" in
    compress)
      case "$format" in
        tar)
          ssh "$host" "$prefix tar -czf '$output' ${files[*]}" && echo "📦 [archive] Comprimido en TAR: $output"
          ;;
        zip)
          ssh "$host" "$prefix zip -r '$output' ${files[*]}" && echo "📦 [archive] Comprimido en ZIP: $output"
          ;;
        gzip)
          for file in "${files[@]}"; do
            ssh "$host" "$prefix gzip -f '$file'" && echo "📦 [archive] GZIP: $file.gz"
          done
          ;;
        bzip2)
          for file in "${files[@]}"; do
            ssh "$host" "$prefix bzip2 -f '$file'" && echo "📦 [archive] BZIP2: $file.bz2"
          done
          ;;
        *)
          echo "❌ [archive] Formato '$format' no soportado para compresión."
          return 1
          ;;
      esac
      ;;
    decompress)
      case "$format" in
        gzip)
          ssh "$host" "$prefix gunzip -f '$archive'" && echo "📂 [archive] Descomprimido GZIP: $archive"
          ;;
        bzip2)
          ssh "$host" "$prefix bunzip2 -f '$archive'" && echo "📂 [archive] Descomprimido BZIP2: $archive"
          ;;
        zip)
          ssh "$host" "$prefix unzip -o '$archive' -d '$dest'" && echo "📂 [archive] Descomprimido ZIP en: $dest"
          ;;
        *)
          echo "❌ [archive] Formato '$format' no soportado para descompresión."
          return 1
          ;;
      esac
      ;;
    extract)
      case "$format" in
        tar)
          ssh "$host" "$prefix tar -xzf '$archive' -C '$dest'" && echo "📂 [archive] Extraído TAR en: $dest"
          ;;
        zip)
          ssh "$host" "$prefix unzip -o '$archive' -d '$dest'" && echo "📂 [archive] Extraído ZIP en: $dest"
          ;;
        *)
          echo "❌ [archive] Formato '$format' no soportado para extracción."
          return 1
          ;;
      esac
      ;;
    *)
      echo "❌ [archive] Acción '$action' no soportada."
      return 1
      ;;
  esac
}

check_dependencies_archive() {
  for cmd in ssh tar gzip bzip2 zip unzip; do
    if ! command -v "$cmd" &> /dev/null; then
      echo "⚠️ [archive] '$cmd' no disponible localmente. Se asumirá que existe en el host remoto."
    else
      echo "✅ [archive] '$cmd' disponible localmente."
    fi
  done
  return 0
}
