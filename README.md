# HACC

[![GitHub Release](https://img.shields.io/github/v/release/baublet/hacc)](https://github.com/baublet/hacc/releases)
[![License](https://img.shields.io/github/license/baublet/hacc)](LICENSE)

**HACC** — **H**ome **A**ssistant **C**laude **C**ode

A Home Assistant add-on that provides a web-based terminal interface to Claude Code, Anthropic's agentic coding assistant. Runs directly in your HA sidebar with YOLO mode support and full access to your HA configuration.

## Features

- **Web Terminal** - Access Claude Code directly from your HA sidebar
- **YOLO Mode** - Auto-approve commands for seamless automation work
- **Full HA Access** - Read/write access to config, add-ons, backups, and more
- **Persistent SSH Keys** - Your keys survive add-on restarts

## Installation

### Add Repository to Home Assistant

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**
2. Click the menu (⋮) → **Repositories**
3. Add: `https://github.com/baublet/hacc`
4. Click **Add** → Close → Refresh the page
5. Find "HACC" and click **Install**
6. Configure your Anthropic API key in the Configuration tab
7. Start the add-on and click "Open Web UI"

### Local Development

```bash
cd /addons
git clone https://github.com/baublet/hacc
```

Then reload add-ons in HA and install from "Local add-ons".

## Configuration

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `anthropic_api_key` | string | Required | Your Anthropic API key |
| `yolo_mode` | boolean | `true` | Auto-approve Claude's commands |
| `default_model` | select | `sonnet` | Model: `sonnet`, `opus`, or `haiku` |
| `theme` | select | `dark` | Terminal theme |

## Usage

1. Click **"HACC"** in your HA sidebar
2. Claude starts in `/config` (your HA configuration directory)
3. Ask Claude to help with automations, scripts, debugging, etc.

### Example Prompts

```
"Create an automation that turns off all lights when everyone leaves home"
"Review my configuration.yaml and suggest optimizations"
"Check the home assistant logs for errors and help me fix them"
```

## File Access

| Path | Description | Access |
|------|-------------|--------|
| `/config` | Home Assistant configuration | Read/Write |
| `/addons` | Local add-ons | Read/Write |
| `/backup` | HA backups | Read/Write |
| `/share` | Shared folder | Read/Write |
| `/media` | Media files | Read/Write |
| `/ssl` | SSL certificates | Read Only |

## Security

YOLO mode grants Claude autonomous command execution. Keep regular backups and review changes when needed.

## License

MIT License - see [LICENSE](LICENSE) file

## Credits

- [Claude Code](https://github.com/anthropics/claude-code) by Anthropic
- [ttyd](https://github.com/tsl0922/ttyd) for web terminal
- [Home Assistant](https://www.home-assistant.io/) community
