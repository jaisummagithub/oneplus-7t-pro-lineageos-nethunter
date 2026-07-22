#!/data/data/com.termux/files/usr/bin/bash
# gw-start.sh  (SANITIZED REFERENCE)
# Launches the agent process with its environment loaded.
# Called by agent-smart-startup.sh inside a tmux window.
#
# Secrets are loaded from ~/.env (NOT committed). This file has no secrets.

set -u

# Load environment (API keys, tokens, etc.) from a private, uncommitted file.
if [ -f "$HOME/.env" ]; then
  set -a
  # shellcheck disable=SC1091
  . "$HOME/.env"
  set +a
fi

# Example: cloud provider region / any non-secret runtime env can go here.
export AGENT_HOME="$HOME/.openclaw"

echo "[gw-start] starting agent gateway..."
exec openclaw gateway start
