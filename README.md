# 🎲 Local MCP Server

A simple MCP (Model Context Protocol) server implementation for learning purposes. This project demonstrates how to build, configure, and deploy a custom MCP server that integrates with Claude Desktop, providing dice rolling functionality for tabletop gaming.

Note, that while the example uses a simple dice-rolling tool, that functionality is intentionally trivial - the real focus of this project is learning how to build and run an MCP server.

## 📚 What is MCP?

The Model Context Protocol (MCP) is a standardized communication protocol that enables AI assistants like Claude to securely connect with external tools, data sources, and services. Think of it as a universal adapter that allows LLMs to interact with the outside world in a structured, secure way.

### Why MCP is Better Than Custom API Integrations

MCP offers significant advantages over traditional custom API integrations:

**Automatic Tool Discovery**: MCP servers automatically tell Claude what they can do and how to use them. No need to manually write API documentation or explain parameters - Claude just knows.

**Built-in Security & Standards**: MCP handles authentication and sandboxing out of the box, plus all MCP servers work the same way. Learn it once, use it everywhere.

**Real-time & AI-Optimized**: Unlike REST APIs built for humans, MCP is designed specifically for AI assistants with structured responses and better error handling.

**Less Integration Work**: Rich metadata and type validation mean fewer bugs and less time spent on integration debugging.

## 🏗️ Architecture Overview

This implementation demonstrates a complete MCP ecosystem running locally on your machine. Here's how all the components work together:

### Component Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Claude        │    │   Docker MCP     │    │   Dice MCP      │
│   Desktop       │◄──►│   Gateway        │◄──►│   Server        │
│                 │    │                  │    │                 │
│ • User Interface│    │ • Protocol       │    │ • Tool          │
│ • Tool Discovery│    │   Translation    │    │   Implementation│
│ • Conversation  │    │ • Server         │    │ • Business      │
│   Management    │    │   Management     │    │   Logic         │
└─────────────────┘    └──────────────────┘    └─────────────────┘
         │                        │                        │
         │                        │                        │
         ▼                        ▼                        ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ Claude Desktop  │    │ Configuration    │    │ Docker          │
│ Config          │    │ Files            │    │ Container       │
│                 │    │                  │    │                 │
│ • Server        │    │ • Catalog        │    │ • Isolated      │
│   Registration  │    │ • Registry       │    │   Environment   │
│ • Connection    │    │ • Tool Metadata  │    │ • Process       │
│   Settings      │    │                  │    │   Management    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Data Flow Explanation

1. **User Interaction**: You ask Claude Desktop to "roll 2d6"
2. **Tool Discovery**: Claude Desktop consults its configuration and discovers the dice rolling tool through the MCP gateway
3. **Request Routing**: Claude Desktop sends a structured MCP request to the Docker MCP Gateway
4. **Container Orchestration**: The gateway starts/communicates with the dice MCP server container
5. **Tool Execution**: The dice server processes the request, rolls the dice, and returns structured results
6. **Response Translation**: The gateway translates the response back to Claude Desktop
7. **User Presentation**: Claude presents the dice roll results in a natural, conversational way

### Key Components Deep Dive

**🐳 Docker Integration**: 
- The MCP server runs in its own isolated Docker container for security and consistency
- The MCP gateway runs in a separate container that orchestrates your server
- Docker handles process lifecycle, resource management, and cleanup for both containers
- Volume mounts provide the gateway access to configuration files

**📁 Configuration Management**:
- `custom.yaml`: Defines your dice server in the MCP catalog with metadata and tool descriptions
- `registry.yaml`: Registers your server in the local MCP registry for discovery
- `claude_desktop_config.json`: Connects Claude Desktop to the MCP gateway with proper container settings

**🌉 MCP Gateway**:
- Serves as an intermediary between Claude Desktop and your MCP servers
- Reads catalog files to discover available servers and route requests to the right containers
- Manages container lifecycle and connection handling automatically
- Provides centralized monitoring and error reporting for easier debugging

**🔧 Tool Schema**:
- Your Python MCP server automatically generates and advertises tool schemas
- Claude Desktop receives these schemas and knows exactly how to call your tools
- No manual API documentation or parameter guessing required
- Type validation and error handling built into the protocol

This architecture demonstrates why MCP is powerful: instead of building custom integrations for each tool, you implement the MCP protocol once and get automatic discovery, type safety, and standardized communication for free.

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

### What Happens During Setup

The `make setup-server` command orchestrates several steps:

1. **Docker Build**: Creates a containerized version of your MCP server
2. **Catalog Update**: Registers your dice server in the MCP catalog with proper metadata
3. **Registry Update**: Adds your server to the local MCP registry for discovery
4. **Claude Configuration**: Updates Claude Desktop's config to connect to the MCP gateway

Each step is atomic and can be run independently for debugging or development purposes.

## 🧹 Cleanup

To remove the MCP server and clean up configuration:

```bash
make remove-server
```

This will stop Docker containers, remove images, and clean up the MCP configuration files.

## 📝 License

This project is licensed under the MIT License.
