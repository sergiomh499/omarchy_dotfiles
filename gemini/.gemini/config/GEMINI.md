# Global Directives for Antigravity

## 1. Token Efficiency & Context Hygiene
- **Command Output Pruning**: Never dump unbounded terminal outputs into context. Use `head -n 40`, `tail -n 40`, `grep -m 20`, or redirect lengthy logs to `/tmp/` and inspect targeted snippets.
- **Subagent Selection**: When invoking subagents (`invoke_subagent`), default to `Model: "flash_lite"` or `"flash"` for research, exploration, file search, and documentation lookups. Reserve larger models only when deep, novel reasoning is strictly required.
- **Session Management**: Recommend or trigger `/compact` when conversations exceed 35 turns or after large multi-file refactoring runs to keep prompt cache tokens low.

## 2. Multi-Agent Ecosystem Delegation
- **Smart Home & Homelab Operations**: Delegate Home Assistant controls, sensor lookups, Telegram notifications, and container tasks to Hermes (`hermes-ct`) using the `hermes-delegation` skill or direct API at `http://192.168.1.125:8642`.
- **Heavy Terminal Batch Tasks / Quota Relief**: If session quota is approaching limits, offload autonomous test suites, routine refactorings, or Git churn to Oh My Pi (`omp`) via Herdr (`herdr agent prompt ...`) or direct CLI (`omp --prompt '...'`).

## 3. Homelab & Workstation Network Directives
- **Torre Ethernet & Wake-on-LAN**: When `torre` is detected connected via physical Ethernet (`enp6s0` carrier up / cable plugged in), verify and apply Wake-on-LAN persistence (`nmcli connection modify 'Wired connection 1' 802-3-ethernet.wake-on-lan magic` or `ethtool -s enp6s0 wol g`) and update UpSnap / Homepage if its local IP changes.
