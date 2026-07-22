#!/data/data/com.termux/files/usr/bin/bash
# agent-smart-startup.sh
# One-tap launcher for an always-on AI agent in Termux.
# Detects internet, picks online (cloud) or offline (local LLM) mode,
# then launches everything under tmux so it survives closing Termux.
#
# SANITIZED REFERENCE - adapt paths/names to your runtime. No secrets here.

set -u

RUNTIME_BIN="openclaw"                 # your agent CLI
CONFIG_UPDATER="$HOME/.update-config.py"
GW_START="$HOME/.gw-start.sh"
LOCK_GLOB="/tmp/${RUNTIME_BIN}-*/.gateway.lock"
TMUX_SESSION="agent"
LLAMA_BIN="/data/user/0/com.termux/llama.cpp/build/bin/llama-server"
LLAMA_MODEL="$HOME/models/model-3b-instruct.gguf"

echo "[startup] cleaning up stale processes + lockfiles..."
killall -9 "$RUNTIME_BIN" 2>/dev/null || true
killall -9 llama-server   2>/dev/null || true
# Lockfiles persist after a force-kill -> remove them or restarts fail silently.
rm -f $LOCK_GLOB 2>/dev/null || true
tmux kill-session -t "$TMUX_SESSION" 2>/dev/null || true

echo "[startup] checking connectivity..."
if ping -c1 -W2 1.1.1.1 >/dev/null 2>&1; then
  MODE="online"
else
  MODE="offline"
fi
echo "[startup] mode = $MODE"

# Rewrite the agent config for the chosen mode (online cloud vs offline local).
python3 "$CONFIG_UPDATER" "$MODE"

# Keep the CPU awake so Android doze doesn't kill the agent.
termux-wake-lock 2>/dev/null || true

if [ "$MODE" = "offline" ]; then
  echo "[startup] launching local llama server..."
  tmux new-session -d -s "$TMUX_SESSION" -n llama \
    "$LLAMA_BIN -m $LLAMA_MODEL --host 127.0.0.1 --port 8080"
  sleep 3
  tmux new-window -t "$TMUX_SESSION" -n gw "$GW_START"
else
  tmux new-session -d -s "$TMUX_SESSION" -n gw "$GW_START"
fi

echo "[startup] done. Attach with:  tmux attach -t $TMUX_SESSION"
