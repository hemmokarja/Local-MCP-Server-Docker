#!/bin/bash
set -e

CLAUDE_CONFIG="$HOME/Library/Application Support/Claude/claude_desktop_config.json"

mkdir -p "$(dirname "$CLAUDE_CONFIG")"
if [ ! -f "$CLAUDE_CONFIG" ]; then
  echo "{}" > "$CLAUDE_CONFIG"
fi

yq -o=json -i '
  .mcpServers["mcp-toolkit-gateway"] = .mcpServers["mcp-toolkit-gateway"] // {} |
  .mcpServers["mcp-toolkit-gateway"].command = "docker" |
  .mcpServers["mcp-toolkit-gateway"].args = [
    "run",
    "-i",
    "--rm",
    "-v", "/var/run/docker.sock:/var/run/docker.sock",
    "-v", "'"$HOME"'/.docker/mcp:/mcp",
    "docker/mcp-gateway",
    "--catalog=/mcp/catalogs/docker-mcp.yaml",
    "--catalog=/mcp/catalogs/custom.yaml",
    "--config=/mcp/config.yaml",
    "--registry=/mcp/registry.yaml",
    "--tools-config=/mcp/tools.yaml",
    "--transport=stdio"
  ]
' "$CLAUDE_CONFIG"

echo "Claude Desktop config updated."
