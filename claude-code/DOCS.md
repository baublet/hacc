# HACC Documentation

**HACC** — **H**ome **A**ssistant **C**laude **C**ode

## Overview

HACC is an AI-powered coding assistant that runs directly in your Home Assistant sidebar. It provides a web-based terminal interface with full access to your HA configuration files, powered by Anthropic's Claude Code.

## Getting Started

1. **Configure your API key** - Enter your Anthropic API key in the add-on configuration
2. **Start the add-on** - Click "Start" on the add-on page
3. **Open the web UI** - Click "Open Web UI" or find "HACC" in your sidebar

## Configuration Options

### `anthropic_api_key` (required)

Your Anthropic API key. Get one at https://console.anthropic.com/

### `yolo_mode` (default: true)

When enabled, Claude will automatically execute commands without asking for confirmation. This is useful for routine HA administration but should be used with caution.

### `default_model` (default: sonnet)

The Claude model to use:
- **sonnet** - Best balance of speed and capability (recommended)
- **opus** - Most capable, slower and more expensive
- **haiku** - Fastest and cheapest, less capable

### `theme` (default: dark)

Terminal color theme: dark or light.

## File Access

Claude has access to the following directories:

| Path | Description | Permissions |
|------|-------------|-------------|
| `/config` | HA configuration | Read/Write |
| `/addons` | Local add-ons | Read/Write |
| `/backup` | Backups | Read/Write |
| `/share` | Shared data | Read/Write |
| `/media` | Media files | Read/Write |
| `/ssl` | SSL certificates | Read Only |

## Tips

- Claude starts in `/config` by default
- Your SSH keys are persisted in `/data/ssh` across restarts
- Check add-on logs if something isn't working

## Example Commands

```
# Automations
"Create an automation that turns off all lights when everyone leaves home"

# Configuration
"Review my configuration.yaml and suggest optimizations"

# Debugging
"Check the home assistant logs for errors and help me fix them"
```

## Support

Report issues at: https://github.com/baublet/hacc/issues
