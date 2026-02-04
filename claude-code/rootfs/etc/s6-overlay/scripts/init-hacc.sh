#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# HACC - Initialization script
# Sets up API keys, SSH, and Claude Code configuration
# ==============================================================================

bashio::log.info "Initializing HACC..."

# Ensure data directories exist
mkdir -p /data/sessions /data/claude-config /data/ssh

# Set ownership to claude user (YOLO mode requires non-root)
chown -R claude:claude /data/sessions /data/claude-config /data/ssh
chown -R claude:claude /home/claude

# Read configuration
API_KEY=$(bashio::config 'anthropic_api_key')
YOLO_MODE=$(bashio::config 'yolo_mode')
DEFAULT_MODEL=$(bashio::config 'default_model')

# Validate API key
if bashio::var.is_empty "${API_KEY}"; then
    bashio::log.error "Anthropic API key is required!"
    bashio::log.error "Please configure it in the add-on settings."
    bashio::exit.nok
fi

# Set up environment file
{
    echo "export ANTHROPIC_API_KEY='${API_KEY}'"
} > /data/claude-config/env.sh

# Map model names to Claude Code format
case "${DEFAULT_MODEL}" in
    "opus")
        MODEL_STRING="opus"
        ;;
    "haiku")
        MODEL_STRING="haiku"
        ;;
    *)
        MODEL_STRING="sonnet"
        ;;
esac
echo "export CLAUDE_CODE_MODEL='${MODEL_STRING}'" >> /data/claude-config/env.sh

# YOLO mode configuration
if bashio::var.true "${YOLO_MODE}"; then
    bashio::log.info "YOLO mode enabled - Claude will auto-approve commands"
    echo "export CLAUDE_DANGEROUSLY_SKIP_PERMISSIONS=true" >> /data/claude-config/env.sh
fi

# Set up SSH directory persistence
if [[ ! -f /data/ssh/id_ed25519 ]]; then
    bashio::log.info "Generating SSH keypair for HACC..."
    ssh-keygen -t ed25519 -f /data/ssh/id_ed25519 -N "" -C "hacc@homeassistant"
    chown claude:claude /data/ssh/id_ed25519 /data/ssh/id_ed25519.pub
fi

# Set up claude user's SSH directory
mkdir -p /home/claude/.ssh
chmod 700 /home/claude/.ssh

# Link SSH keys if they exist
if [[ -f /data/ssh/id_ed25519 ]]; then
    ln -sf /data/ssh/id_ed25519 /home/claude/.ssh/id_ed25519
    ln -sf /data/ssh/id_ed25519.pub /home/claude/.ssh/id_ed25519.pub
    chmod 600 /data/ssh/id_ed25519
fi

# Link known_hosts if it exists
if [[ -f /data/ssh/known_hosts ]]; then
    ln -sf /data/ssh/known_hosts /home/claude/.ssh/known_hosts
fi

# Create Claude Code settings directory
mkdir -p /home/claude/.claude

# Link settings.json if it exists in persistent storage
if [[ -f /data/claude-config/settings.json ]]; then
    ln -sf /data/claude-config/settings.json /home/claude/.claude/settings.json
fi

# Ensure .claude.json exists with onboarding complete (required to skip interactive prompts)
# This file must be at ~/.claude.json, not ~/.claude/settings.json
if [[ ! -f /data/claude-config/.claude.json ]]; then
    echo '{"hasCompletedOnboarding": true}' > /data/claude-config/.claude.json
fi
ln -sf /data/claude-config/.claude.json /home/claude/.claude.json

# Set ownership for claude user home
chown -R claude:claude /home/claude

# Set git safe directory for /config (for both root and claude user)
git config --global --add safe.directory /config
gosu claude git config --global --add safe.directory /config

bashio::log.info "HACC initialization complete!"
