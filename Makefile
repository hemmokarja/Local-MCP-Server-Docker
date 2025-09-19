HOME_DIR := $(shell echo $$HOME)
PROJECT_DIR := dice-mcp-server
CLAUDE_CONFIG := "$(HOME_DIR)/Library/Application Support/Claude/claude_desktop_config.json"
CUSTOM_CATALOG := "$(HOME_DIR)/.docker/mcp/catalogs/custom.yaml"
REGISTRY_FILE := "$(HOME_DIR)/.docker/mcp/registry.yaml"

.PHONY: setup-server check-yq build catalog registry claude remove-server

# Check that user has at least yq4
check-yq:
	@command -v yq >/dev/null 2>&1 || { echo "Error: yq is not installed. Install v4+ from https://github.com/mikefarah/yq/releases"; exit 1; }
	@YQ_MAJOR=$$(yq --version | grep -Eo '([0-9]+)\.' | head -1 | tr -d '.') ; \
	if [ "$$YQ_MAJOR" -lt 4 ]; then \
	  echo "Error: yq version $$YQ_MAJOR detected. Please install yq v4 or higher."; \
	  exit 1; \
	fi
	@echo "yq v4+ detected."

# Build Docker image
build:
	docker build -t dice-mcp-server .

# Create or modify custom MCP catalog
catalog:
	@scripts/update-catalog.sh

# Modify MCP registry
registry:
	@scripts/update-registry.sh

# Configure Claude Desktop
claude:
	@scripts/config-claude.sh

# Main command to configure and start the MCP server
setup-server: check-yq build catalog registry claude
	@echo "Dice MCP server setup complete. Please restart Claude Desktop to see the new tools."

# Main command to stop the MCP server and clean up
remove-server:
	@containers=$$(docker ps -a | grep dice-mcp-server | awk '{print $$1}'); \
	if [ -n "$$containers" ]; then \
		docker rm -f $$containers; \
	fi
	@docker rmi -f dice-mcp-server || true
	@echo "Docker containers/images removed."

	@yq -i 'del(.registry.dice)' $(CUSTOM_CATALOG)
	@echo "Removed dice entry from custom.yaml."

	@yq -i 'del(.registry.dice)' $(REGISTRY_FILE)
	@echo "Removed dice entry from registry.yaml."

	@yq -o=json -i 'del(.mcpServers["mcp-toolkit-gateway"])' $(CLAUDE_CONFIG)
	@echo "Removed mcp-toolkit-gateway entry from Claude config."

	@echo "Dice MCP server removal complete."
