#!/usr/bin/env bash
# Module: api
# Description: Cliente declarativo para APIs REST y SOAP (GET, POST, PUT, DELETE, SOAP)
# License: GPLv3
# Author: Luis GuLo
# Version: 1.0
# Dependencies: curl, jq, xmllint

api_task() {
  local host="$1"; shift
  declare -A args
  local headers=()
  local method body url output parse

  for arg in "$@"; do
    key="${arg%%=*}"
    value="${arg#*=}"
    case "$key" in
      headers) IFS=',' read -r -a headers <<< "$value" ;;
      body) body="$value" ;;
      url) url="$value" ;;
      method) method="${value,,}" ;;  # lowercase
      output) output="$value" ;;
      parse) parse="${value,,}" ;;
    esac
  done

  local curl_opts=("-sS" "-X" "$method" "$url")
  for h in "${headers[@]}"; do
    curl_opts+=("-H" "$h")
  done
  [[ -n "$body" ]] && curl_opts+=("-d" "$body")

  echo "🌐 [api] Ejecutando $method → $url"
  local response
  response=$(curl "${curl_opts[@]}" 2>/dev/null)

  if [[ -n "$output" ]]; then
    echo "$response" > "$output"
    echo "💾 [api] Respuesta guardada en: $output"
  fi

  case "$parse" in
    json)
      echo "$response" | jq '.' 2>/dev/null || echo "⚠️ [api] No se pudo parsear como JSON"
      ;;
    xml)
      echo "$response" | xmllint --format - 2>/dev/null || echo "⚠️ [api] No se pudo parsear como XML"
      ;;
    *)
      echo "$response"
      ;;
  esac
}

check_dependencies_api() {
  for cmd in curl jq xmllint; do
    if ! command -v "$cmd" &> /dev/null; then
      echo "⚠️ [api] '$cmd' no disponible localmente. Se asumirá que existe en el host remoto."
    else
      echo "✅ [api] '$cmd' disponible localmente."
    fi
  done
  return 0
}
