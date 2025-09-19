#!/bin/bash
set -e

REGISTRY_FILE="$HOME/.docker/mcp/registry.yaml"

mkdir -p "$(dirname "$REGISTRY_FILE")"

# Ensure file exists
if [ ! -f "$REGISTRY_FILE" ]; then
  echo "registry: {}" > "$REGISTRY_FILE"
fi

yq -i '
  .registry.dice = .registry.dice // {"ref": ""}
' "$REGISTRY_FILE"

echo "registry.yaml updated."
