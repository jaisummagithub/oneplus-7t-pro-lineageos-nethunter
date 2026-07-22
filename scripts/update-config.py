#!/usr/bin/env python3
"""update-config.py  (SANITIZED REFERENCE)

Rewrites an agent's JSON config for online vs offline operation.

    python3 update-config.py online
    python3 update-config.py offline

- online:  use a cloud model with a fallback chain, enable remote chat channel
- offline: point at the local llama.cpp server, disable remote chat so the
           agent doesn't crash on DNS failures with no internet

No secrets live in this file. Credentials belong in your .env / secret store,
which the runtime loads separately. Never commit tokens.
"""
import json
import sys
from pathlib import Path

CONFIG_PATH = Path.home() / ".openclaw" / "openclaw.json"

# --- adjust these to your providers/models -------------------------------
ONLINE_MODELS = [
    "cloud/primary-model",      # e.g. your main hosted model
    "cloud/secondary-model",    # fallback #1
    "local/small-model",        # fallback #2 (still works if llama is up)
]
OFFLINE_MODEL = "local/small-model"
LOCAL_LLM_BASE_URL = "http://127.0.0.1:8080/v1"
# -------------------------------------------------------------------------


def load() -> dict:
    if CONFIG_PATH.exists():
        return json.loads(CONFIG_PATH.read_text())
    return {}


def save(cfg: dict) -> None:
    CONFIG_PATH.parent.mkdir(parents=True, exist_ok=True)
    CONFIG_PATH.write_text(json.dumps(cfg, indent=2))


def set_online(cfg: dict) -> None:
    cfg.setdefault("model", {})
    cfg["model"]["default"] = ONLINE_MODELS[0]
    cfg["model"]["fallbacks"] = ONLINE_MODELS[1:]
    # enable remote chat channel (Discord/Telegram/etc.)
    cfg.setdefault("channels", {}).setdefault("chat", {})["enabled"] = True


def set_offline(cfg: dict) -> None:
    cfg.setdefault("model", {})
    cfg["model"]["default"] = OFFLINE_MODEL
    cfg["model"]["fallbacks"] = []
    # point the local provider at the llama.cpp server
    cfg.setdefault("providers", {}).setdefault("local", {})["baseUrl"] = LOCAL_LLM_BASE_URL
    # disable remote chat so no-internet DNS failures don't crash the gateway
    cfg.setdefault("channels", {}).setdefault("chat", {})["enabled"] = False


def main() -> int:
    mode = (sys.argv[1] if len(sys.argv) > 1 else "online").lower()
    cfg = load()
    if mode == "offline":
        set_offline(cfg)
    else:
        set_online(cfg)
    save(cfg)
    print(f"[update-config] wrote {CONFIG_PATH} in '{mode}' mode")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
