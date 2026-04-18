[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com)
[![tests](https://github.com/trebormc/ddev-ai-ssh/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/trebormc/ddev-ai-ssh/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/trebormc/ddev-ai-ssh)](https://github.com/trebormc/ddev-ai-ssh/commits)
[![release](https://img.shields.io/github/v/release/trebormc/ddev-ai-ssh)](https://github.com/trebormc/ddev-ai-ssh/releases/latest)

# ddev-ai-ssh

A DDEV add-on that enables SSH access to the web container for AI agents. Installs sshd in the web container and generates per-project SSH keys, so AI containers (OpenCode, Claude Code, Ralph) can execute commands (drush, composer, phpunit, phpstan) without needing the Docker socket.

> **Part of [DDEV AI Workspace](https://github.com/trebormc/ddev-ai-workspace)** — a modular ecosystem of DDEV add-ons for AI-powered Drupal development. Install the full stack with one command: `ddev add-on get trebormc/ddev-ai-workspace`
>
> Created by [Robert Menetray](https://menetray.com) · Sponsored by [DruScan](https://druscan.com)

> **Note:** This add-on is typically installed automatically as a dependency of [ddev-opencode](https://github.com/trebormc/ddev-opencode) or [ddev-claude-code](https://github.com/trebormc/ddev-claude-code). You rarely need to install it directly.

## Why SSH?

SSH provides per-project isolation with minimal attack surface. Each DDEV project has a unique ed25519 key pair, so AI containers can only connect to the web container of their own project. Different projects have different keys, preventing cross-project access.

## What it does

1. Installs openssh-server in the web container (via `web-build/Dockerfile.ai-ssh`)
2. Generates a per-project ed25519 key pair in `.ddev/.agent-ssh-keys/` (gitignored)
3. Configures the ddev user's `authorized_keys` on every `ddev start`
4. Hardens sshd: no root login, no password auth, no TCP/X11 forwarding

AI containers use `ssh web <command>` to run commands in the web container (drush, composer, phpunit, etc.).

## Quick Start

The **recommended way** to install this add-on is through the [DDEV AI Workspace](https://github.com/trebormc/ddev-ai-workspace):

```bash
ddev add-on get trebormc/ddev-ai-workspace
ddev restart
```

This add-on is also **automatically installed** as a dependency when you install [ddev-opencode](https://github.com/trebormc/ddev-opencode) or [ddev-claude-code](https://github.com/trebormc/ddev-claude-code).

### Standalone installation

```bash
ddev add-on get trebormc/ddev-ai-ssh
ddev restart
```

## Commands

| Command | Description |
|---------|-------------|
| `ddev ai-ssh-status` | Check if sshd is running and keys are configured |

## Configuration

No configuration needed. Keys are generated automatically on install and reused across restarts.

SSH keys are stored in `.ddev/.agent-ssh-keys/` and automatically added to `.gitignore`. Each developer generates their own keys on the first install.

## Security

- **Per-project isolation**: each project has a unique key pair. Containers from project A cannot connect to project B.
- **Key-only authentication**: no passwords, no root login.
- **Hardened sshd**: TCP forwarding and X11 forwarding disabled.
- **ForceCommand**: SSH sessions always start in `/var/www/html` with DDEV environment variables.

## Uninstallation

```bash
ddev add-on remove ddev-ai-ssh
ddev restart
```

SSH keys in `.ddev/.agent-ssh-keys/` are NOT deleted automatically.

## Part of DDEV AI Workspace

| Repository | Description | Relationship |
|------------|-------------|--------------|
| [ddev-ai-workspace](https://github.com/trebormc/ddev-ai-workspace) | Meta add-on that installs the full AI development stack. | Workspace |
| [ddev-opencode](https://github.com/trebormc/ddev-opencode) | OpenCode AI CLI container. | Auto-installs this add-on |
| [ddev-claude-code](https://github.com/trebormc/ddev-claude-code) | Claude Code CLI container. | Auto-installs this add-on |
| [ddev-ralph](https://github.com/trebormc/ddev-ralph) | Autonomous AI task orchestrator. | Uses SSH indirectly |
| [ddev-beads](https://github.com/trebormc/ddev-beads) | Git-backed task tracker. | Sibling dependency |
| [ddev-playwright-mcp](https://github.com/trebormc/ddev-playwright-mcp) | Headless Playwright browser. | Sibling dependency |
| [drupal-ai-agents](https://github.com/trebormc/drupal-ai-agents) | 10 agents, 12 rules, 24 skills for Drupal development. | Agent configuration |

## Disclaimer

This project is an independent initiative by [Robert Menetray](https://menetray.com), sponsored by [DruScan](https://druscan.com). It is not affiliated with Anthropic, OpenCode, Beads, Playwright, Microsoft, or DDEV. AI-generated code may contain errors. Always review changes before deploying to production.

## License

Apache-2.0. See [LICENSE](LICENSE).
