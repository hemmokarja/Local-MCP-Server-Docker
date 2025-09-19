# 🎲 Local MCP Server

A simple MCP (Model Context Protocol) server implementation for learning purposes. This project demonstrates how to build, configure, and deploy a custom MCP server that integrates with Claude Desktop, providing dice rolling functionality for tabletop gaming.

## 📚 What is MCP?

The Model Context Protocol (MCP) is a standardized way for AI assistants like Claude to securely connect with external tools and data sources. MCP servers expose specific capabilities (tools, resources, or prompts) that Claude can discover and use during conversations.

In this implementation:
- **MCP Server**: A Python application running in Docker that provides dice rolling functionality
- **MCP Gateway**: Docker's MCP gateway that manages communication between Claude Desktop and MCP servers
- **Tool Registration**: Configuration files that register our dice server in Claude Desktop's tool ecosystem

This setup allows you to ask Claude to roll dice (e.g., "roll 2d6" or "throw 3d20") and it will execute the dice rolling logic through the MCP server.

This project runs an MCP server **locally on your machine using Docker**. The server communicates with Claude Desktop through local Docker containers and configuration files. However, it's worth noting that MCP servers can also be deployed remotely on cloud infrastructure, allowing multiple users to access shared tools and resources.

## ⚙️ Prerequisites

- **Docker Desktop** with MCP support (version 4.42.0 or later)
- **yq v4+** - YAML processor ([download here](https://github.com/mikefarah/yq/releases))
- **Make** - Build automation tool
- **uv** - Python package manager
- **Claude Desktop** - AI assistant application

## 🚀 Quick Start

1. **Set up the MCP server:**
   ```bash
   make setup-server
   ```

2. **Restart Claude Desktop** to load the new MCP configuration

3. **Verify installation:**
   - Open the tool menu in Claude Desktop
   - Look for "mcp-toolkit-gateway" in the available tools

4. **Test the dice rolling:**
   - Ask Claude: "Roll 2d6" or "Throw some dice: 3d20"
   - Claude will use the MCP server to execute the dice rolls

## 🧹 Cleanup

To remove the MCP server and clean up configuration:

```bash
make remove-server
```

This will stop Docker containers, remove images, and clean up the MCP configuration files.

## 📝 License

This project is licensed under the MIT License.
