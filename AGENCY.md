# Flutter & Stitch Agentic Workflow

This project is optimized for an agentic workflow using **Antigravity**, **Stitch**, and **MCP**.

## MCP Servers

To enable advanced Flutter and Design capabilities, ensure the following MCP servers are configured in your Antigravity settings:

### 1. Flutter MCP Server
Provides real-time project analysis, hot reload, and widget tree inspection.
- **Command:** `dart`
- **Args:** `["mcp-server"]`

### 2. Stitch MCP Server
Connects your Stitch design projects to this workspace.
- **Command:** `npx`
- **Args:** `["@google/stitch-mcp-server"]`
- **Env:** `STITCH_API_KEY=your_key_here`

## Stitch Skills

The following skills are available in the `skills/` directory to automate UI implementation:

- **[UI Implementation](skills/ui_implementation.md)**: Converts Stitch designs to Flutter components using GoRouter and Riverpod.
- **[Documentation Generation](skills/docs_generation.md)**: Automatically updates `DESIGN.md` and `ARCH.md` based on code changes.
1