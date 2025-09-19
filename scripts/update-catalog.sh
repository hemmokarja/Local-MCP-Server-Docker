#!/bin/bash
set -e

CUSTOM_CATALOG="$HOME/.docker/mcp/catalogs/custom.yaml"

mkdir -p "$(dirname "$CUSTOM_CATALOG")"

# Ensure the file exists
if [ ! -f "$CUSTOM_CATALOG" ]; then
  echo "{}" > "$CUSTOM_CATALOG"
fi

yq -i '
  .yamlversion = "2" |
  .name = "custom" |
  .displayName = "Custom MCP Servers" |
  .registry.dice.description = "Dice rolling for tabletop games" |
  .registry.dice.title = "Dice Roller" |
  .registry.dice.type = "server" |
  .registry.dice.dateAdded = "2025-01-01T00:00:00Z" |
  .registry.dice.image = "dice-mcp-server:latest" |
  .registry.dice.ref = "" |
  .registry.dice.readme = "" |
  .registry.dice.toolsUrl = "" |
  .registry.dice.source = "" |
  .registry.dice.upstream = "" |
  .registry.dice.icon = "" |
  .registry.dice.tools = [{"name":"roll_dice"}] |
  .registry.dice.metadata.category = "productivity" |
  .registry.dice.metadata.tags = ["gaming","dice","randomization","tabletop"] |
  .registry.dice.metadata.license = "MIT" |
  .registry.dice.metadata.owner = "local"
' "$CUSTOM_CATALOG"

echo "custom.yaml updated."
