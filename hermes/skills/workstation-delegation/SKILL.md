---
name: workstation-delegation
description: Delegate coding, heavy refactoring, or desktop tasks to Oh My Pi (omp) or Antigravity (agy) on the local workstation.
version: 1.0.0
author: Homelab Operations
platforms: [linux]
metadata:
  hermes:
    tags: [delegation, agy, omp, opencode, workstation, coding]
    category: software-development
    requires_toolsets: [terminal]
---

# Workstation Agent Delegation

When a user request requires heavy programming, codebase refactoring, IDE inspection, or large reasoning budgets that exceed local resources, delegate the task to the workstation agents.

## Available Workstation Agents

1. **Antigravity CLI (`agy`)**: Powered by Google Pro tier (Gemini 3.8 Flash Medium). Best for broad architecture, multi-file inspection, and complex problem solving.
2. **Oh My Pi (`omp`)**: Powered by OpenCode Go (`mimo-v2.6-flash` / `deepseek-v4-pro`). Best for rapid code editing, tests, git operations, and terminal tasks.

## Delegation Commands via SSH Tunnel (Port 2222)

### 1. Delegate directly to Antigravity CLI
```bash
ssh -o BatchMode=yes -p 2222 sergio@127.0.0.1 "agy --prompt TASK_DESCRIPTION"
```

### 2. Delegate directly to Oh My Pi
```bash
ssh -o BatchMode=yes -p 2222 sergio@127.0.0.1 "omp --prompt TASK_DESCRIPTION"
```

### 3. Prompt a running agent in a hc terminal (herdr-app)
```bash
# List live terminals (hc = herdr-core CLI; on the portatil it lives in ~/.local/bin)
ssh -o BatchMode=yes -p 2222 sergio@127.0.0.1 "export PATH=\$HOME/.local/bin:\$PATH; hc ls"

# Paste a prompt into a terminal (address from hc ls, e.g. t3). NEVER --wait:
# the timeout kills the turn and the answer is lost (see quota-aware-dispatch).
ssh -o BatchMode=yes -p 2222 sergio@127.0.0.1 "export PATH=\$HOME/.local/bin:\$PATH; hc send <terminal> 'TASK_DESCRIPTION'"

# Status and final report
ssh -o BatchMode=yes -p 2222 sergio@127.0.0.1 "export PATH=\$HOME/.local/bin:\$PATH; hc get <terminal> --json"
ssh -o BatchMode=yes -p 2222 sergio@127.0.0.1 "export PATH=\$HOME/.local/bin:\$PATH; hc read <terminal>"
```
