# Token Efficiency & Multi-Agent Guidelines

## 1. Context & Token Preservation
- Never dump raw large outputs into context. Use `head -n 50`, `tail -n 50`, `grep -m 20` or redirect to temporary files.
- Keep sessions focused. Periodically compact or refresh context when turns exceed 30.

## 2. Cross-Agent Specialization
- **Hermes (CT 125)**: Home Assistant IoT devices, sensors, notifications, Telegram updates. Free tier (`beam-free` $0).
- **Oh My Pi (omp)**: High-speed local code refactoring, test execution, git operations (`mimo-v2.6-flash`).
- **Antigravity (agy)**: Architectural reasoning, multi-agent orchestration, complex debugging (Pro Plan - Gemini 3.8 Flash Medium).
