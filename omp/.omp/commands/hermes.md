---
description: Delegate a task to Hermes Agent (Home Assistant, Telegram, Homelab)
globs: ["*"]
---

# /hermes

Delegate a task to Hermes Agent on `hermes-ct`.

Run:
```bash
curl -s -X POST http://192.168.1.125:8642/v1/chat/completions \
  -H "Authorization: Bearer a8bf90ac8a189a5a4cff711c887cd4223d6cb9494baa91b07f046fd2b2d8bbb6" \
  -H "Content-Type: application/json" \
  -d '{"model":"hermes-agent","messages":[{"role":"user","content":"$ARGUMENTS"}]}'
```
Or execute via SSH:
```bash
ssh hermes-ct "hermes chat -q '$ARGUMENTS'"
```
