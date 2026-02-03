#!/command/with-contenv bashio
# shellcheck shell=bash
# ==============================================================================
# HACC - Initialization script
# Sets up API keys, SSH, and Claude Code configuration
# ==============================================================================

bashio::log.info "Initializing HACC..."

# Ensure data directories exist
mkdir -p /data/sessions /data/claude-config /data/ssh

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
fi

mkdir -p /root/.ssh
chmod 700 /root/.ssh

# Link SSH keys if they exist
if [[ -f /data/ssh/id_ed25519 ]]; then
    ln -sf /data/ssh/id_ed25519 /root/.ssh/id_ed25519
    ln -sf /data/ssh/id_ed25519.pub /root/.ssh/id_ed25519.pub
    chmod 600 /root/.ssh/id_ed25519
fi

# Link known_hosts if it exists
if [[ -f /data/ssh/known_hosts ]]; then
    ln -sf /data/ssh/known_hosts /root/.ssh/known_hosts
fi

# Create Claude Code settings directory
mkdir -p /root/.claude

# Link settings if they exist
if [[ -f /data/claude-config/settings.json ]]; then
    ln -sf /data/claude-config/settings.json /root/.claude/settings.json
fi

# Set git safe directory for /config
git config --global --add safe.directory /config

bashio::log.info "HACC initialization complete!"
